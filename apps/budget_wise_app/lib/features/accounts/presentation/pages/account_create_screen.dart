import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/account.dart';
import '../bloc/account_cubit.dart';

class AccountCreateScreen extends StatefulWidget {
  const AccountCreateScreen({super.key});

  @override
  State<AccountCreateScreen> createState() => _AccountCreateScreenState();
}

class _AccountCreateScreenState extends State<AccountCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _type = 'cash';
  String _currency = 'THB';
  double _openingBalance = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D648D),
        title:
            const Text('Create Account', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Account Name'),
                onChanged: (v) => _name = v,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'bank', child: Text('Bank')),
                  DropdownMenuItem(value: 'debit', child: Text('Debit')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'cash'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Opening Balance'),
                keyboardType: TextInputType.number,
                onChanged: (v) => _openingBalance = double.tryParse(v) ?? 0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Currency'),
                initialValue: 'THB',
                onChanged: (v) => _currency = v,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4D648D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final now = DateTime.now();
                    final account = Account(
                      id: '',
                      name: _name,
                      type: _type,
                      openingBalance: _openingBalance,
                      balance: _openingBalance,
                      currency: _currency,
                      createdAt: now,
                      updatedAt: now,
                    );
                    await context.read<AccountCubit>().createAccount(account);
                    if (context.mounted) Navigator.pop(context, true);
                  }
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
