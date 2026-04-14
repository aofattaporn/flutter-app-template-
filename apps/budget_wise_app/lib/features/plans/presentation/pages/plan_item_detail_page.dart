import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../di/injection.dart';
import '../../../../domain/entities/plan_item.dart';
import '../../../../domain/repositories/plan_repository.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../transactions/presentation/bloc/transaction_editor_bloc.dart';
import '../../../transactions/presentation/pages/transaction_editor_page.dart';
import '../bloc/active_plan_bloc.dart';
import 'plan_item_editor_page.dart';

class PlanItemDetailPage extends StatefulWidget {
  final PlanItem item;

  const PlanItemDetailPage({super.key, required this.item});

  @override
  State<PlanItemDetailPage> createState() => _PlanItemDetailPageState();
}

class _PlanItemDetailPageState extends State<PlanItemDetailPage> {
  late PlanItem _item;
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final txns = await getIt<TransactionRepository>()
          .getTransactionsByPlanItemId(_item.id);
      if (mounted) {
        setState(() {
          _transactions = txns;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        context.showSnackBar('Failed to load transactions: $e', isError: true);
      }
    }
  }

  Future<void> _navigateToEditItem() async {
    final state = context.read<ActivePlanBloc>().state;
    if (state.plan == null) return;

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => PlanItemEditorPage(
          plan: state.plan!,
          existingItem: _item,
          currentTotalPlanned: state.totalPlannedExpenses,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result != null && mounted) {
      context.read<ActivePlanBloc>().add(
            UpdatePlanItemRequested(
              itemId: _item.id,
              name: result['name'] as String,
              expectedAmount: result['amount'] as double,
            ),
          );
      // Refresh the plan to get updated item
      context.read<ActivePlanBloc>().add(const RefreshActivePlan());
      // Update local item with new values
      setState(() {
        _item = _item.copyWith(
          name: result['name'] as String,
          expectedAmount: result['amount'] as double,
        );
      });
    }
  }

  Future<void> _confirmDeleteItem() async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Delete Item',
      message: 'Are you sure you want to delete "${_item.name}"?',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (confirmed && mounted) {
      context.read<ActivePlanBloc>().add(DeletePlanItemRequested(_item.id));
      Navigator.pop(context, true);
    }
  }

  Future<void> _navigateToEditTransaction(Transaction txn) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => TransactionEditorBloc(
            transactionRepository: getIt<TransactionRepository>(),
            accountRepository: getIt<AccountRepository>(),
            planRepository: getIt<PlanRepository>(),
          ),
          child: TransactionEditorPage(transaction: txn),
        ),
        fullscreenDialog: true,
      ),
    );

    if (result == true && mounted) {
      _loadTransactions();
      context.read<ActivePlanBloc>().add(const RefreshActivePlan());
    }
  }

  Future<void> _confirmDeleteTransaction(Transaction txn) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Delete Transaction',
      message: 'Are you sure you want to delete this transaction? '
          'The account balance will be reverted.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );

    if (!confirmed || !mounted) return;

    try {
      final accountRepo = getIt<AccountRepository>();
      final accounts = await accountRepo.getAccounts();
      final account = accounts.firstWhere((a) => a.id == txn.accountId);

      switch (txn.type) {
        case TransactionType.expense:
          await accountRepo
              .updateAccount(account.copyWith(balance: account.balance + txn.amount));
          break;
        case TransactionType.income:
          await accountRepo
              .updateAccount(account.copyWith(balance: account.balance - txn.amount));
          break;
        case TransactionType.transfer:
          await accountRepo
              .updateAccount(account.copyWith(balance: account.balance + txn.amount));
          break;
      }

      await getIt<TransactionRepository>().deleteTransaction(txn.id);
      getIt<PlanRepository>().invalidateCache();

      if (mounted) {
        context.showSnackBar('Transaction deleted');
        _loadTransactions();
        context.read<ActivePlanBloc>().add(const RefreshActivePlan());
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Failed to delete: $e', isError: true);
      }
    }
  }

  void _showTransactionActionSheet(Transaction txn) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.edit_outlined, color: Color(0xFF4D648D)),
                  title: const Text('Edit Transaction'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _navigateToEditTransaction(txn);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red[400]),
                  title: Text('Delete Transaction',
                      style: TextStyle(color: Colors.red[400])),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmDeleteTransaction(txn);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D648D),
        elevation: 0,
        title: Text(_item.name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _navigateToEditItem,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: _confirmDeleteItem,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTransactions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              _buildTransactionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final progressColor = _item.isOverBudget
        ? Colors.red[600]!
        : _item.isNearLimit
            ? const Color(0xFFB1A296)
            : const Color(0xFF4D648D);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.category,
                    size: 20, color: Color(0xFF4D648D)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _item.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50)),
                    ),
                    const SizedBox(height: 2),
                    Text('Expense Category',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('Planned', CurrencyUtils.formatCurrency(_item.expectedAmount)),
          const SizedBox(height: 10),
          _buildInfoRow('Actual', CurrencyUtils.formatCurrency(_item.actualAmount)),
          const SizedBox(height: 10),
          _buildInfoRow(
            _item.isOverBudget ? 'Over Budget' : 'Remaining',
            CurrencyUtils.formatCurrency(
                _item.isOverBudget ? _item.overAmount : _item.remainingAmount),
            valueColor: _item.isOverBudget ? Colors.red[600] : Colors.green[600],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _item.progressPercentage,
              backgroundColor: Colors.grey[100],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
          if (_item.isOverBudget || _item.isNearLimit) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _item.isOverBudget
                      ? Icons.error_outline
                      : Icons.warning_amber_outlined,
                  size: 14,
                  color: progressColor,
                ),
                const SizedBox(width: 4),
                Text(
                  _item.isOverBudget ? 'Over planned amount' : 'Near limit',
                  style: TextStyle(fontSize: 12, color: progressColor),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF171717),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTIONS SECTION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTransactionsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Referenced Transactions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_transactions.length} transaction${_transactions.length == 1 ? '' : 's'}',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: Color(0xFF4D648D)),
              ),
            )
          else if (_transactions.isEmpty)
            _buildEmptyTransactions()
          else
            ..._transactions.map(_buildTransactionRow),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 36, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'No transactions yet',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(Transaction txn) {
    final timeFormat = DateFormat('MMM d, h:mm a');
    final isExpense = txn.type == TransactionType.expense;
    final isIncome = txn.type == TransactionType.income;

    final icon = isExpense
        ? Icons.remove_circle_outline
        : isIncome
            ? Icons.add_circle_outline
            : Icons.swap_horiz;
    final iconColor = isExpense
        ? Colors.red[400]
        : isIncome
            ? Colors.green[400]
            : const Color(0xFF4D648D);
    final amountPrefix = isExpense ? '-' : isIncome ? '+' : '';
    final amountColor = isExpense
        ? Colors.red[600]
        : isIncome
            ? Colors.green[600]
            : const Color(0xFF171717);

    return GestureDetector(
      onTap: () => _showTransactionActionSheet(txn),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor!.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.description ??
                        txn.type.name[0].toUpperCase() +
                            txn.type.name.substring(1),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF171717)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeFormat.format(txn.occurredAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Text(
              '$amountPrefix${CurrencyUtils.formatCurrency(txn.amount)}',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600, color: amountColor),
            ),
          ],
        ),
      ),
    );
  }
}
