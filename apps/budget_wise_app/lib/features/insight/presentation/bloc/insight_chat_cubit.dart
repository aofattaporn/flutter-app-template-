import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─── Chat Message Model ─────────────────────────────────────────────────────

class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  List<Object?> get props => [text, isUser, timestamp];
}

// ─── Chat State ─────────────────────────────────────────────────────────────

enum ChatStatus { idle, sending, error }

class InsightChatState extends Equatable {
  final List<ChatMessage> messages;
  final ChatStatus status;
  final String? errorMessage;

  const InsightChatState({
    this.messages = const [],
    this.status = ChatStatus.idle,
    this.errorMessage,
  });

  InsightChatState copyWith({
    List<ChatMessage>? messages,
    ChatStatus? status,
    String? errorMessage,
  }) {
    return InsightChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, status, errorMessage];
}

// ─── Chat Cubit ─────────────────────────────────────────────────────────────

class InsightChatCubit extends Cubit<InsightChatState> {
  final SupabaseClient _supabaseClient;

  InsightChatCubit({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient,
        super(const InsightChatState());

  Future<void> sendMessage(String query) async {
    if (query.trim().isEmpty) return;

    final userMessage = ChatMessage(text: query.trim(), isUser: true);
    emit(state.copyWith(
      messages: [...state.messages, userMessage],
      status: ChatStatus.sending,
      errorMessage: null,
    ));

    try {
      final res = await _supabaseClient.functions.invoke(
        'budgetwise-gemini',
        body: {'query': query.trim()},
      );

      final data = res.data as Map<String, dynamic>?;
      final responseText =
          data?['response'] as String? ?? 'No response received.';

      final botMessage = ChatMessage(text: responseText, isUser: false);
      emit(state.copyWith(
        messages: [...state.messages, botMessage],
        status: ChatStatus.idle,
      ));
    } catch (e) {
      final errorMsg = 'Failed to get response. Please try again. ${e.toString()}';
      emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: errorMsg,
      ));
    }
  }

  void clearChat() {
    emit(const InsightChatState());
  }
}
