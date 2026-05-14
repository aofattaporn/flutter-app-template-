import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/insight_chat_cubit.dart';

class InsightChatSheet extends StatefulWidget {

final String planId;

  const InsightChatSheet({super.key, required this.planId});
  

  @override
  State<InsightChatSheet> createState() => _InsightChatSheetState();
}

class _InsightChatSheetState extends State<InsightChatSheet> {
  final _controller = TextEditingController();
  final _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    // Load chat history from DB when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InsightChatCubit>().loadChatHistory();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<InsightChatCubit>().sendMessage(text, widget.planId);
    _controller.clear();
  }

  Future<void> _confirmClearChat() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear chat?'),
        content:
            const Text('This will delete all chat messages. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<InsightChatCubit>().clearChat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.5,
        minChildSize: 0.4,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [0.5, 1.0],
        expand: false,
        builder: (context, scrollController) {
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: context.colors.cardBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // ── Drag handle + title: manually drives the sheet ──
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragUpdate: (details) {
                    final delta =
                        details.delta.dy / MediaQuery.of(context).size.height;
                    final newSize =
                        (_sheetController.size - delta).clamp(0.4, 1.0);
                    _sheetController.jumpTo(newSize);
                  },
                  onVerticalDragEnd: (details) {
                    // Snap to nearest size
                    final target =
                        _sheetController.size > 0.75 ? 1.0 : 0.5;
                    _sheetController.animateTo(
                      target,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHandle(),
                      _buildTitle(),
                      const Divider(height: 1),
                    ],
                  ),
                ),
                // ── Messages: uses scrollController for scroll↔drag ──
                Expanded(
                  child: _buildMessageList(scrollController),
                ),
                _buildInput(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageList(ScrollController scrollController) {
    return BlocConsumer<InsightChatCubit, InsightChatState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
      },
      builder: (context, state) {
        if (state.status == ChatStatus.loading) {
          return Center(
            child: CircularProgressIndicator(color: context.colors.accent),
          );
        }

        if (state.messages.isEmpty) {
          // Wrap empty state in a scrollable so the DraggableScrollableSheet
          // still receives scroll gestures from this area.
          return SingleChildScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              // Fill the available space so the scroll view is draggable
              height: MediaQuery.of(context).size.height * 0.35,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline,
                          size: 40, color: context.colors.textTertiary),
                      const SizedBox(height: 12),
                      Text(
                        'Ask anything about your budget',
                        style: context.styles.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'e.g. "How much did I spend on food?" or\n"Am I over budget this month?"',
                        style: context.styles.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: state.messages.length +
              (state.status == ChatStatus.sending ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.messages.length) {
              return _buildTypingIndicator();
            }
            return _buildMessageBubble(state.messages[index]);
          },
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.colors.divider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, size: 20, color: context.colors.accent),
          const SizedBox(width: 8),
          Text('AI Budget Assistant', style: context.styles.titleMedium),
          const Spacer(),
          BlocBuilder<InsightChatCubit, InsightChatState>(
            builder: (context, state) {
              if (state.messages.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.delete_outline,
                    size: 20, color: context.colors.textTertiary),
                onPressed: () => _confirmClearChat(),
                tooltip: 'Clear chat',
                splashRadius: 18,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? context.colors.accent
              : context.colors.scaffoldBg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: SelectableText(
          message.text,
          style: TextStyle(
            fontSize: 14,
            color: isUser ? Colors.white : context.colors.textPrimary,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.colors.scaffoldBg,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.accent,
              ),
            ),
            const SizedBox(width: 8),
            Text('Thinking...', style: context.styles.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return BlocBuilder<InsightChatCubit, InsightChatState>(
      builder: (context, state) {
        final isSending = state.status == ChatStatus.sending;

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
          decoration: BoxDecoration(
            color: context.colors.cardBg,
            border: Border(
              top: BorderSide(color: context.colors.divider, width: 0.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.status == ChatStatus.error &&
                  state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.expense,
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !isSending,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      style: TextStyle(
                        fontSize: 14,
                        color: context.colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask about your budget...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: context.colors.textTertiary,
                        ),
                        filled: true,
                        fillColor: context.colors.scaffoldBg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: isSending ? null : _send,
                    icon: Icon(
                      Icons.send_rounded,
                      color: isSending
                          ? context.colors.textTertiary
                          : context.colors.accent,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
