import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/account_model.dart';

/// Remote datasource for account data using Supabase
class AccountRemoteDataSource {
  final SupabaseClient client;
  static const String _tableName = 'accounts';

  AccountRemoteDataSource(this.client);

  /// Fetch all accounts ordered by creation date
  Future<List<AccountModel>> fetchAccounts() async {
    try {
      final response = await client
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => AccountModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch accounts: $e');
    }
  }

  /// Get a single account by ID
  Future<AccountModel?> getAccountById(String id) async {
    try {
      final response = await client
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return AccountModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch account: $e');
    }
  }

  /// Create a new account
  Future<AccountModel> createAccount(AccountModel account) async {
    try {
      print('🔵 DataSource: Creating account in Supabase...');
      final data = {
        'name': account.name,
        'type': account.type,
        'opening_balance': account.openingBalance,
        'balance': account.balance,
        'currency': account.currency,
      };
      print('🔵 DataSource: Data to insert: $data');

      final response = await client
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      print('✅ DataSource: Account created successfully - Response: $response');
      return AccountModel.fromJson(response);
    } catch (e) {
      print('❌ DataSource: Failed to create account - $e');
      throw Exception('Failed to create account: $e');
    }
  }

  /// Update an existing account
  Future<AccountModel> updateAccount(AccountModel account) async {
    try {
      final data = {
        'name': account.name,
        'type': account.type,
        'opening_balance': account.openingBalance,
        'balance': account.balance,
        'currency': account.currency,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await client
          .from(_tableName)
          .update(data)
          .eq('id', account.id)
          .select()
          .single();

      return AccountModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update account: $e');
    }
  }

  /// Delete an account
  Future<void> deleteAccount(String id) async {
    try {
      await client.from(_tableName).delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }

  /// Get total balance across all accounts
  Future<double> getTotalBalance() async {
    try {
      final accounts = await fetchAccounts();
      return accounts.fold<double>(
        0.0,
        (sum, account) => sum + account.balance,
      );
    } catch (e) {
      throw Exception('Failed to calculate total balance: $e');
    }
  }
}

