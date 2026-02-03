import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/account_model.dart';

class AccountRemoteDataSource {
  final SupabaseClient client;

  AccountRemoteDataSource(this.client);

  Future<List<AccountModel>> fetchAccounts() async {
    final response = await client.from('accounts').select().order('created_at');
    return (response as List).map((e) => AccountModel.fromJson(e)).toList();
  }

  Future<AccountModel> createAccount(AccountModel account) async {
    final response = await client
        .from('accounts')
        .insert(account.toJson())
        .select()
        .single();
    return AccountModel.fromJson(response);
  }
}
