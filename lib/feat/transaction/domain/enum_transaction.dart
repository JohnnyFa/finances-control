enum TransactionType { income, expense }

extension TransactionTypeX on TransactionType {
  String get emoji {
    switch (this) {
      case TransactionType.income:
        return '💰';
      case TransactionType.expense:
        return '💸';
    }
  }

  /// chave de i18n
  String get labelKey {
    switch (this) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
    }
  }

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
          (e) => e.name.toLowerCase() == value.toLowerCase(),
    );
  }
}