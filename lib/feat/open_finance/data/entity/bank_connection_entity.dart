import 'package:finances_control/feat/open_finance/domain/bank_connection.dart';

class BankConnectionEntity {
  final int? id;
  final String bankName;
  final String accountMasked;
  final int autoSyncEnabled;
  final String createdAt;

  const BankConnectionEntity({
    this.id,
    required this.bankName,
    required this.accountMasked,
    required this.autoSyncEnabled,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'bankName': bankName,
    'accountMasked': accountMasked,
    'autoSyncEnabled': autoSyncEnabled,
    'createdAt': createdAt,
  };

  factory BankConnectionEntity.fromMap(Map<String, dynamic> map) {
    return BankConnectionEntity(
      id: map['id'] as int?,
      bankName: map['bankName'] as String,
      accountMasked: map['accountMasked'] as String,
      autoSyncEnabled: map['autoSyncEnabled'] as int,
      createdAt: map['createdAt'] as String,
    );
  }

  BankConnection toDomain() => BankConnection(
    id: id,
    bankName: bankName,
    accountMasked: accountMasked,
    autoSyncEnabled: autoSyncEnabled == 1,
    createdAt: DateTime.parse(createdAt),
  );

  static BankConnectionEntity fromDomain(BankConnection connection) {
    return BankConnectionEntity(
      id: connection.id,
      bankName: connection.bankName,
      accountMasked: connection.accountMasked,
      autoSyncEnabled: connection.autoSyncEnabled ? 1 : 0,
      createdAt: connection.createdAt.toIso8601String(),
    );
  }
}
