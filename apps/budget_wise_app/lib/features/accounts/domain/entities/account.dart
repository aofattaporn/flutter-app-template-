import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String name;
  final String type;
  final double openingBalance;
  final double balance;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalance,
    required this.balance,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, name, type, openingBalance, balance, currency, createdAt, updatedAt];
}
