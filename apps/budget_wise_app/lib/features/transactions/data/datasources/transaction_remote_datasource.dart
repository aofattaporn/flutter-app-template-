import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';

class TransactionRemoteDataSource {
  final SupabaseClient client;
  static const String _tableName = 'transactions';

  TransactionRemoteDataSource(this.client);

  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final response = await client
          .from(_tableName)
          .select()
          .order('occurred_at', ascending: false);

      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<TransactionModel> createTransaction(
      TransactionModel transaction) async {
    try {
      final data = {
        'account_id': transaction.accountId,
        'plan_item_id': transaction.planItemId,
        'type': transaction.type,
        'amount': transaction.amount,
        'description': transaction.description,
        'occurred_at': transaction.occurredAt.toIso8601String(),
      };

      final response =
          await client.from(_tableName).insert(data).select().single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }

  Future<TransactionModel> updateTransaction(
      TransactionModel transaction) async {
    try {
      final data = {
        'account_id': transaction.accountId,
        'plan_item_id': transaction.planItemId,
        'type': transaction.type,
        'amount': transaction.amount,
        'description': transaction.description,
        'occurred_at': transaction.occurredAt.toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await client
          .from(_tableName)
          .update(data)
          .eq('id', transaction.id)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await client.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  Future<List<TransactionModel>> fetchRecentTransactions({int limit = 5}) async {
    try {
      final response = await client
          .from(_tableName)
          .select()
          .order('occurred_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recent transactions: $e');
    }
  }
}
