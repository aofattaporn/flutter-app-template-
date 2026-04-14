import 'package:equatable/equatable.dart';

enum TransactionType { expense, income, transfer }

class Transaction extends Equatable {
  final String id;
  final String accountId;
  final String? planItemId;
  final TransactionType type;
  final double amount;
  final String? description;
  final DateTime occurredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Transaction({
    required this.id,
    required this.accountId,
    this.planItemId,
    required this.type,
    required this.amount,
    this.description,
    required this.occurredAt,
    this.createdAt,
    this.updatedAt,
  });

  Transaction copyWith({
    String? id,
    String? accountId,
    String? planItemId,
    TransactionType? type,
    double? amount,
    String? description,
    DateTime? occurredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      planItemId: planItemId ?? this.planItemId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        accountId,
        planItemId,
        type,
        amount,
        description,
        occurredAt,
        createdAt,
        updatedAt,
      ];
}
