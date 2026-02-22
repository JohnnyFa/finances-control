class TransactionEntity {
  final int? id;
  final int amount;
  final String type;
  final String category;
  final String date;
  final String description;
  final int year;
  final int month;
  final String? source;
  final String? externalId;
  final int? bankConnectionId;

  TransactionEntity({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.description,
    required this.year,
    required this.month,
    this.source,
    this.externalId,
    this.bankConnectionId,
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
    'source': source,
    'externalId': externalId,
    'bankConnectionId': bankConnectionId,
  };

  factory TransactionEntity.fromMap(Map<String, dynamic> map) => TransactionEntity(
    id: map['id'] as int?,
    amount: map['amount'] as int,
    type: map['type'] as String,
    category: map['category'] as String,
    date: map['date'] as String,
    description: (map['description'] as String?) ?? '',
    year: map['year'] as int,
    month: map['month'] as int,
    source: map['source'] as String?,
    externalId: map['externalId'] as String?,
    bankConnectionId: map['bankConnectionId'] as int?,
  );
}
