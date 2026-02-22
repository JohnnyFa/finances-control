class BankConnection {
  final int? id;
  final String bankName;
  final String accountMasked;
  final bool autoSyncEnabled;
  final DateTime createdAt;

  const BankConnection({
    this.id,
    required this.bankName,
    required this.accountMasked,
    required this.autoSyncEnabled,
    required this.createdAt,
  });
}
