class AdsConfig {
  final bool globalEnabled;
  final bool home;
  final bool transactions;
  final bool budgetCategory;
  final bool newTransaction;

  AdsConfig({
    required this.globalEnabled,
    required this.home,
    required this.transactions,
    required this.budgetCategory,
    required this.newTransaction,
  });

  factory AdsConfig.fromJson(Map<String, dynamic>? json) {
    return AdsConfig(
      globalEnabled: json?['global_enabled'] ?? true,
      home: json?['home'] ?? true,
      transactions: json?['transactions'] ?? true,
      budgetCategory: json?['budget_category'] ?? true,
      newTransaction: json?['new_transaction'] ?? true,
    );
  }
}
