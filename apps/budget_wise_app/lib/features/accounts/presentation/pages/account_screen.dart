import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/account.dart';
import '../bloc/account_cubit.dart';
import 'account_create_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D648D),
        elevation: 0,
        title: const Text('Accounts', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AccountLoaded) {
            if (state.accounts.isEmpty) {
              return const Center(child: Text('No accounts yet.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.accounts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final account = state.accounts[i];
                return _AccountCard(account: account);
              },
            );
          } else if (state is AccountError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4D648D),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final created = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountCreateScreen()),
          );
          if (created == true && context.mounted) {
            context.read<AccountCubit>().fetchAccounts();
          }
        },
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final Account account;
  const _AccountCard({required this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(_iconForType(account.type), color: const Color(0xFF4D648D)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(account.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(account.type,
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ],
            ),
          ),
          Text('${account.balance.toStringAsFixed(2)} ${account.currency}',
              style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'cash':
        return Icons.money;
      case 'bank':
        return Icons.account_balance;
      case 'debit':
        return Icons.credit_card;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
