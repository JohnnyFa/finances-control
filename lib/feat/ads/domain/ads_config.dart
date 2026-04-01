class AdsConfig {
  final bool home;
  final bool transactions;
  final bool budgetCategory;
  final bool newTransaction;

  AdsConfig({
    required this.home,
    required this.transactions,
    required this.budgetCategory,
    required this.newTransaction,
  });

  factory AdsConfig.fromJson(Map<String, dynamic>? json) {
    return AdsConfig(
      home: json?['home'] ?? true,
      transactions: json?['transactions'] ?? true,
      budgetCategory: json?['budget_category'] ?? true,
      newTransaction: json?['new_transaction'] ?? true,
    );
  }
}