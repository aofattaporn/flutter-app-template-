import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/account.dart';
import '../bloc/account_bloc.dart';
import '../widgets/dashed_border_painter.dart';
import 'account_create_screen.dart';
import 'account_detail_page.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// Account Screen - Main accounts list view
/// Displays all user accounts with total balance summary
/// ═══════════════════════════════════════════════════════════════════════════
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(const FetchAccountsRequested());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NAVIGATION METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Navigate to create account screen
  Future<void> _navigateToCreateAccount() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AccountBloc>(),
          child: const AccountCreateScreen(),
        ),
        fullscreenDialog: true,
      ),
    );

    // Refresh accounts list if account was created
    if (result == true && mounted) {
      context.read<AccountBloc>().add(const FetchAccountsRequested());
    }
  }

  /// Handle account item tap - navigate to detail page
  Future<void> _onAccountTap(Account account) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<AccountBloc>(),
          child: AccountDetailPage(account: account),
        ),
      ),
    );

    if (mounted) {
      context.read<AccountBloc>().add(const RefreshAccountsRequested());
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOG METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  void _showAccountMenu(Account account) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            context.styles.sheetHandle(),
            ListTile(
              leading: Icon(Icons.edit_outlined, color: context.colors.accent),
              title: const Text('Edit Account'),
              onTap: () {
                Navigator.pop(context);
                _onAccountTap(account);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: context.colors.expense),
              title: Text('Delete Account', style: TextStyle(color: context.colors.expense)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(account);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Account account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete "${account.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[700],
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      context.read<AccountBloc>().add(DeleteAccountRequested(account.id));
      
      // Wait a moment then refresh
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.read<AccountBloc>().add(const FetchAccountsRequested());
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - MAIN
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffoldBg,
      appBar: context.styles.appBar(
        title: 'Accounts',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreateAccount,
          ),
        ],
      ),
      body: BlocConsumer<AccountBloc, AccountState>(
        listener: _handleStateChanges,
        builder: (context, state) => _buildBody(state),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - STATES
  // ═══════════════════════════════════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar() {
    return context.styles.appBar(
      title: 'Accounts',
      showBack: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _navigateToCreateAccount,
        ),
      ],
    );
  }

  void _handleStateChanges(BuildContext context, AccountState state) {
    if (state is AccountError) {
      context.showSnackBar(state.message, isError: true);
    }
  }

  Widget _buildBody(AccountState state) {
    if (state is AccountLoading) {
      return Center(child: CircularProgressIndicator(color: context.colors.primary));
    }
    if (state is AccountLoaded) return _buildAccountsList(state);
    if (state is AccountError) return _buildErrorState(state.message);
    return const SizedBox.shrink();
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.colors.textTertiary),
            const SizedBox(height: 16),
            Text('Something went wrong', style: context.styles.titleMedium),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: context.styles.bodySmall),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<AccountBloc>().add(const FetchAccountsRequested()),
              style: context.styles.primaryButton,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD - ACCOUNT LIST CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAccountsList(AccountLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AccountBloc>().add(const RefreshAccountsRequested());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Total balance summary
            _buildTotalBalanceSummary(state),
            
            // Accounts section header
            _buildSectionHeader(state.accountCount),
            
            // Accounts list
            _buildAccountsListView(state.accounts),
            
            // Add account button
            _buildAddAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBalanceSummary(AccountLoaded state) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: context.styles.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Balance', style: context.styles.label),
          const SizedBox(height: 8),
          Text(CurrencyUtils.formatCurrency(state.totalBalance), style: context.styles.displayLarge),
          const SizedBox(height: 8),
          Text(
            'Across ${state.accountCount} ${state.accountCount == 1 ? 'account' : 'accounts'}',
            style: context.styles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Text('Your Accounts', style: context.styles.titleMedium),
    );
  }

  Widget _buildAccountsListView(List<Account> accounts) {
    if (accounts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.account_balance_wallet_outlined, size: 36, color: context.colors.textTertiary),
              const SizedBox(height: 16),
              Text('No accounts yet', style: context.styles.bodyLarge),
              const SizedBox(height: 8),
              Text('Add an account to start tracking', style: context.styles.bodySmall),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      itemCount: accounts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final account = accounts[index];
        return _AccountCard(
          account: account,
          onTap: () => _onAccountTap(account),
          onMenuTap: () => _showAccountMenu(account),
        );
      },
    );
  }

  Widget _buildAddAccountButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: InkWell(
        onTap: _navigateToCreateAccount,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: context.colors.cardBg,
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: context.colors.border, style: BorderStyle.solid, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, size: 20, color: context.colors.textTertiary),
              const SizedBox(height: 4),
              Text('Add Account', style: context.styles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════
/// Account Card Widget - Individual account display
/// ═══════════════════════════════════════════════════════════════════════════
class _AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  const _AccountCard({
    required this.account,
    required this.onTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.cardPadding),
        decoration: context.styles.card,
        child: Row(
          children: [
            context.styles.iconBox(
              icon: _getIconForType(account.type),
              size: AppDimens.iconMd,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.name, style: context.styles.bodyLarge),
                  const SizedBox(height: 2),
                  Text(_getTypeName(account.type), style: context.styles.caption),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyUtils.formatCurrency(account.balance),
                  style: context.styles.titleMedium,
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: context.colors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }

  /// Get icon for account type
  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'cash':
        return Icons.money_rounded;
      case 'bank':
        return Icons.account_balance;
      case 'debit':
        return Icons.credit_card;
      case 'ewallet':
      case 'e-wallet':
        return Icons.wallet;
      default:
        return Icons.account_balance_wallet;
    }
  }

  /// Get display name for account type
  String _getTypeName(String type) {
    switch (type.toLowerCase()) {
      case 'cash':
        return 'Cash';
      case 'bank':
        return 'Bank Account';
      case 'debit':
        return 'Debit Card';
      case 'ewallet':
      case 'e-wallet':
        return 'E-Wallet';
      default:
        return type;
    }
  }
}


