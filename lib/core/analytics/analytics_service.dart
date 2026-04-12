abstract class AnalyticsService {
  Future<void> trackAppOpen();
  Future<void> trackAppBackground();
  Future<void> trackAppForeground();

  Future<void> trackHomeView();
  Future<void> trackTransactionsView();
  Future<void> trackAddTransactionView();
  Future<void> trackBudgetView();
  Future<void> trackBookListView();
  Future<void> trackOnboardingView();

  Future<void> trackOnboardingStart();
  Future<void> trackOnboardingCompleted();
  Future<void> trackOnboardingSkipped();

  Future<void> trackClickAddTransactionButton();
  Future<void> trackAddTransactionSuccess({
    required String category,
    required int amount,
    required String type,
  });

  Future<void> trackClickTransactionsTab();
  Future<void> trackFilterTransactions({required String? type});
  Future<void> trackClickTransactionItem();

  Future<void> trackClickOpenBudgetScreen();
  Future<void> trackClickAddBudget();
  Future<void> trackAddBudgetSuccess({
    required String category,
    required int amount,
  });

  Future<void> trackClickOpenBooksScreen();
  Future<void> trackViewBooks();
  Future<void> trackClickBook({
    required String bookName,
    required String category,
  });
  Future<void> trackOpenAmazon({
    required String productId,
    required String bookName,
  });

  Future<void> trackClickUploadCsv();
  Future<void> trackUploadCsv({
    required bool success,
    required int itemsCount,
  });

  Future<void> trackViewAd();
  Future<void> trackClickAd();

  Future<void> trackClickHomeTab();
  Future<void> trackClickBudgetTab();
  Future<void> trackClickBooksTab();

  Future<void> trackViewPaywall();
  Future<void> trackStartPurchase();
  Future<void> trackPurchaseSuccess();
}
