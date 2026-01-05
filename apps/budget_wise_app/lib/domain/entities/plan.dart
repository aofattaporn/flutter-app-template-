import 'package:equatable/equatable.dart';

/// Plan entity representing a budget plan
class Plan extends Equatable {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final double? expectedIncome;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Plan({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.expectedIncome,
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Check if plan is currently in progress (within date range)
  bool get isInProgress {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate.add(const Duration(days: 1)));
  }

  /// Get formatted period string
  String get formattedPeriod {
    final startMonth = _getMonthName(startDate.month);
    final endMonth = _getMonthName(endDate.month);
    return '$startMonth ${startDate.day} - $endMonth ${endDate.day}, ${endDate.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Plan copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    double? expectedIncome,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      expectedIncome: expectedIncome ?? this.expectedIncome,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        startDate,
        endDate,
        expectedIncome,
        isActive,
        createdAt,
        updatedAt,
      ];
}
