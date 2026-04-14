import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../../domain/entities/plan_item.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_editor_bloc.dart';

class TransactionEditorPage extends StatefulWidget {
  final Transaction? transaction;

  const TransactionEditorPage({super.key, this.transaction});

  @override
  State<TransactionEditorPage> createState() => _TransactionEditorPageState();
}

class _TransactionEditorPageState extends State<TransactionEditorPage> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.transaction?.description ?? '',
    );
    context.read<TransactionEditorBloc>().add(
          TransactionEditorLoaded(transaction: widget.transaction),
        );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - MAIN
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionEditorBloc, TransactionEditorState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        final isLoading = state.status == TransactionEditorStatus.loading ||
            state.status == TransactionEditorStatus.initial;
        final showActions = state.status == TransactionEditorStatus.ready ||
            state.status == TransactionEditorStatus.saving ||
            state.status == TransactionEditorStatus.error;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(state),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4D648D)),
                )
              : Column(
                  children: [
                    Expanded(child: _buildForm(state)),
                    if (showActions) _buildBottomActions(state),
                  ],
                ),
        );
      },
    );
  }

  void _handleStateChanges(
      BuildContext context, TransactionEditorState state) {
    if (state.status == TransactionEditorStatus.error &&
        state.errorMessage != null) {
      context.showSnackBar(state.errorMessage!, isError: true);
    }
    if (state.status == TransactionEditorStatus.success) {
      context.showSnackBar(
        state.isEditing
            ? 'Transaction updated successfully'
            : 'Transaction created successfully',
      );
      Navigator.pop(context, true);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - APP BAR
  // ═══════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar(TransactionEditorState state) {
    return AppBar(
      backgroundColor: const Color(0xFF4D648D),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        state.isEditing ? 'Edit Transaction' : 'Create Transaction',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - FORM
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildForm(TransactionEditorState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransactionTypeSelector(state),
          const SizedBox(height: 24),
          _buildAmountInput(state),
          const SizedBox(height: 24),
          _buildAccountSelector(state),
          const SizedBox(height: 24),
          if (state.type == TransactionType.expense) ...[
            _buildPlanItemSelector(state),
            const SizedBox(height: 24),
          ],
          _buildDateTimeSelector(state),
          const SizedBox(height: 24),
          _buildDescriptionInput(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - TRANSACTION TYPE SELECTOR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTransactionTypeSelector(TransactionEditorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Type',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTypeButton(
              state,
              type: TransactionType.expense,
              icon: Icons.remove,
              label: 'Expense',
            ),
            const SizedBox(width: 8),
            _buildTypeButton(
              state,
              type: TransactionType.income,
              icon: Icons.add,
              label: 'Income',
            ),
            const SizedBox(width: 8),
            _buildTypeButton(
              state,
              type: TransactionType.transfer,
              icon: Icons.swap_horiz,
              label: 'Transfer',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeButton(
    TransactionEditorState state, {
    required TransactionType type,
    required IconData icon,
    required String label,
  }) {
    final isSelected = state.type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => context
            .read<TransactionEditorBloc>()
            .add(TransactionTypeChanged(type)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4D648D) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4D648D)
                  : const Color(0xFFE5E5E5),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - AMOUNT INPUT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAmountInput(TransactionEditorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E5E5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '฿',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Color(0xFF171717),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      fontSize: 28,
                      color: Color(0xFFA3A3A3),
                    ),
                  ),
                  onChanged: (value) => context
                      .read<TransactionEditorBloc>()
                      .add(TransactionAmountChanged(value)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - ACCOUNT SELECTOR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAccountSelector(TransactionEditorState state) {
    final label =
        state.type == TransactionType.income ? 'To Account' : 'From Account';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => _showAccountPicker(state),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E5E5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF4D648D),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.selectedAccount?.name ?? 'Select Account',
                        style: TextStyle(
                          fontSize: 14,
                          color: state.selectedAccount != null
                              ? const Color(0xFF171717)
                              : Colors.grey[400],
                        ),
                      ),
                      if (state.selectedAccount != null)
                        Text(
                          'Balance: ${CurrencyUtils.formatCurrency(state.selectedAccount!.balance)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAccountPicker(TransactionEditorState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AccountPickerSheet(
        accounts: state.accounts,
        selectedId: state.selectedAccountId,
        onSelected: (id) {
          context
              .read<TransactionEditorBloc>()
              .add(TransactionAccountChanged(id));
          Navigator.pop(context);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - PLAN ITEM SELECTOR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPlanItemSelector(TransactionEditorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Plan Item (Optional)',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Icon(Icons.info_outline, size: 16, color: Colors.grey[400]),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: state.planItems.isNotEmpty
              ? () => _showPlanItemPicker(state)
              : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E5E5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.selectedPlanItem?.name ?? 'Select Plan Item',
                        style: TextStyle(
                          fontSize: 14,
                          color: state.selectedPlanItem != null
                              ? const Color(0xFF171717)
                              : Colors.grey[400],
                        ),
                      ),
                      if (state.selectedPlanItem != null)
                        Text(
                          'Remaining: ${CurrencyUtils.formatCurrency(state.selectedPlanItem!.remainingAmount)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Plan items help you track spending against your plan.',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  void _showPlanItemPicker(TransactionEditorState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _PlanItemPickerSheet(
        planItems: state.planItems,
        selectedId: state.selectedPlanItemId,
        onSelected: (id) {
          context
              .read<TransactionEditorBloc>()
              .add(TransactionPlanItemChanged(id));
          Navigator.pop(context);
        },
        onClear: () {
          context
              .read<TransactionEditorBloc>()
              .add(const TransactionPlanItemChanged(''));
          Navigator.pop(context);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - DATE/TIME SELECTOR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDateTimeSelector(TransactionEditorState state) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDate(state),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormat.format(state.occurredAt),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF171717),
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.calendar_today,
                          size: 18, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(state),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeFormat.format(state.occurredAt),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF171717),
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.access_time,
                          size: 18, color: Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pickDate(TransactionEditorState state) async {
    final date = await showDatePicker(
      context: context,
      initialDate: state.occurredAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      context
          .read<TransactionEditorBloc>()
          .add(TransactionDateChanged(date));
    }
  }

  Future<void> _pickTime(TransactionEditorState state) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.occurredAt),
    );
    if (time != null && mounted) {
      context
          .read<TransactionEditorBloc>()
          .add(TransactionTimeChanged(time));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - DESCRIPTION INPUT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          style: const TextStyle(fontSize: 14, color: Color(0xFF171717)),
          decoration: InputDecoration(
            hintText: 'e.g. Coffee & Breakfast',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4D648D)),
            ),
          ),
          onChanged: (value) => context
              .read<TransactionEditorBloc>()
              .add(TransactionDescriptionChanged(value)),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - BOTTOM ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBottomActions(TransactionEditorState state) {
    final isSaving = state.status == TransactionEditorStatus.saving;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E5E5))),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: isSaving ? null : () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF525252),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: isSaving
                    ? null
                    : () => context
                        .read<TransactionEditorBloc>()
                        .add(const TransactionEditorSubmitted()),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSaving
                        ? const Color(0xFF4D648D).withValues(alpha: 0.6)
                        : const Color(0xFF4D648D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            state.isEditing
                                ? 'Update Transaction'
                                : 'Save Transaction',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BOTTOM SHEETS
// ═══════════════════════════════════════════════════════════════════════════

class _AccountPickerSheet extends StatelessWidget {
  final List<Account> accounts;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const _AccountPickerSheet({
    required this.accounts,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF171717),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...accounts.map((account) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF4D648D),
                    size: 18,
                  ),
                ),
                title: Text(account.name),
                subtitle: Text(
                  'Balance: ${CurrencyUtils.formatCurrency(account.balance)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                trailing: account.id == selectedId
                    ? const Icon(Icons.check_circle, color: Color(0xFF4D648D))
                    : null,
                onTap: () => onSelected(account.id),
              )),
        ],
      ),
    );
  }
}

class _PlanItemPickerSheet extends StatelessWidget {
  final List<PlanItem> planItems;
  final String selectedId;
  final ValueChanged<String> onSelected;
  final VoidCallback onClear;

  const _PlanItemPickerSheet({
    required this.planItems,
    required this.selectedId,
    required this.onSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Plan Item',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF171717),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.clear, color: Colors.grey[400], size: 18),
            ),
            title: const Text('None'),
            subtitle: Text(
              'No plan item linked',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            trailing: selectedId.isEmpty
                ? const Icon(Icons.check_circle, color: Color(0xFF4D648D))
                : null,
            onTap: onClear,
          ),
          ...planItems.map((item) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EDF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.category,
                    color: Color(0xFF4D648D),
                    size: 18,
                  ),
                ),
                title: Text(item.name),
                subtitle: Text(
                  'Remaining: ${CurrencyUtils.formatCurrency(item.remainingAmount)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                trailing: item.id == selectedId
                    ? const Icon(Icons.check_circle, color: Color(0xFF4D648D))
                    : null,
                onTap: () => onSelected(item.id),
              )),
        ],
      ),
    );
  }
}
