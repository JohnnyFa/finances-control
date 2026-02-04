class TransactionEntity {
  final int? id;
  final int amount;
  final String type;
  final String category;
  final String date;
  final String description;
  final int year;
  final int month;

  TransactionEntity({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.description, required this.year, required this.month,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'type': type,
    'category': category,
    'date': date,
    'description': description,
    'year': year,
    'month': month,
  };

  factory TransactionEntity.fromMap(Map<String, dynamic> map) =>
      TransactionEntity(
        id: map['id'] as int?,
        amount: map['amount'] as int,
        type: map['type'] as String,
        category: map['category'] as String,
        date: map['date'] as String,
        description: map['description'] as String,
        year: map['year'] as int,
        month: map['month'] as int,
      );
}
