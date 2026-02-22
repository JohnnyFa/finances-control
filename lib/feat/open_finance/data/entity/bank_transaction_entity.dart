class BankTransactionEntity {
  final int? id;
  final int bankConnectionId;
  final String externalId;
  final int amount;
  final String description;
  final String paidAt;
  final String importedAt;

  const BankTransactionEntity({
    this.id,
    required this.bankConnectionId,
    required this.externalId,
    required this.amount,
    required this.description,
    required this.paidAt,
    required this.importedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'bankConnectionId': bankConnectionId,
    'externalId': externalId,
    'amount': amount,
    'description': description,
    'paidAt': paidAt,
    'importedAt': importedAt,
  };
}
