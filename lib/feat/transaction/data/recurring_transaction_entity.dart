class RecurringTransactionEntity {
  final int? id;
  final String amount;
  final String type;
  final String category;
  final int dayOfMonth;
  final String startDate;
  final String? endDate;
  final String? description;
  final int active;

  RecurringTransactionEntity({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.dayOfMonth,
    required this.startDate,
    this.description,
    required this.active,
    this.endDate,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'type': type,
    'category': category,
    'dayOfMonth': dayOfMonth,
    'startDate': startDate,
    'description': description,
    'active': active,
    'endDate': endDate,
  };

  factory RecurringTransactionEntity.fromMap(Map<String, dynamic> map) =>
      RecurringTransactionEntity(
        id: map['id'] as int?,
        amount: map['amount'] as String,
        type: map['type'] as String,
        category: map['category'] as String,
        dayOfMonth: map['dayOfMonth'] as int,
        startDate: map['startDate'] as String,
        description: map['description'] as String?,
        active: map['active'] as int,
        endDate: map['endDate'] as String?,
      );
}
