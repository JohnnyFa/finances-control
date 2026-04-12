import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_service.dart';

class AnalyticsServiceImpl implements AnalyticsService {
  AnalyticsServiceImpl(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> _logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> trackAppOpen() => _logEvent('app_open');

  @override
  Future<void> trackAppBackground() => _logEvent('app_background');

  @override
  Future<void> trackAppForeground() => _logEvent('app_foreground');

  @override
  Future<void> trackHomeView() => _logEvent('home_view');

  @override
  Future<void> trackTransactionsView() => _logEvent('transactions_view');

  @override
  Future<void> trackAddTransactionView() => _logEvent('add_transaction_view');

  @override
  Future<void> trackBudgetView() => _logEvent('budget_view');

  @override
  Future<void> trackBookListView() => _logEvent('book_list_view');

  @override
  Future<void> trackOnboardingView() => _logEvent('onboarding_view');

  @override
  Future<void> trackOnboardingStart() => _logEvent('onboarding_start');

  @override
  Future<void> trackOnboardingCompleted() => _logEvent('onboarding_completed');

  @override
  Future<void> trackOnboardingSkipped() => _logEvent('onboarding_skipped');

  @override
  Future<void> trackClickAddTransactionButton() =>
      _logEvent('click_add_transaction_button');

  @override
  Future<void> trackAddTransactionSuccess({
    required String category,
    required int amount,
    required String type,
  }) => _logEvent(
    'add_transaction_success',
    parameters: {
      'category': category,
      'amount': amount,
      'type': type,
    },
  );

  @override
  Future<void> trackClickTransactionsTab() => _logEvent('click_transactions_tab');

  @override
  Future<void> trackFilterTransactions({required String? type}) =>
      _logEvent('filter_transactions', parameters: {'type': type ?? 'all'});

  @override
  Future<void> trackClickTransactionItem() => _logEvent('click_transaction_item');

  @override
  Future<void> trackClickOpenBudgetScreen() =>
      _logEvent('click_open_budget_screen');

  @override
  Future<void> trackClickAddBudget() => _logEvent('click_add_budget');

  @override
  Future<void> trackAddBudgetSuccess({
    required String category,
    required int amount,
  }) => _logEvent(
    'add_budget_success',
    parameters: {
      'category': category,
      'amount': amount,
    },
  );

  @override
  Future<void> trackClickOpenBooksScreen() => _logEvent('click_open_books_screen');

  @override
  Future<void> trackViewBooks() => _logEvent('view_books');

  @override
  Future<void> trackClickBook({
    required String bookName,
    required String category,
  }) => _logEvent(
    'click_book',
    parameters: {
      'book_name': bookName,
      'category': category,
    },
  );

  @override
  Future<void> trackOpenAmazon({
    required String productId,
    required String bookName,
  }) => _logEvent(
    'open_amazon',
    parameters: {
      'product_id': productId,
      'book_name': bookName,
    },
  );

  @override
  Future<void> trackClickUploadCsv() => _logEvent('click_upload_csv');

  @override
  Future<void> trackUploadCsv({
    required bool success,
    required int itemsCount,
  }) => _logEvent(
    'upload_csv',
    parameters: {
      'success': success ? 1 : 0,
      'items_count': itemsCount,
    },
  );

  @override
  Future<void> trackViewAd() => _logEvent('view_ad');

  @override
  Future<void> trackClickAd() => _logEvent('click_ad');

  @override
  Future<void> trackClickHomeTab() => _logEvent('click_home_tab');

  @override
  Future<void> trackClickBudgetTab() => _logEvent('click_budget_tab');

  @override
  Future<void> trackClickBooksTab() => _logEvent('click_books_tab');

  @override
  Future<void> trackViewPaywall() => _logEvent('view_paywall');

  @override
  Future<void> trackStartPurchase() => _logEvent('start_purchase');

  @override
  Future<void> trackPurchaseSuccess() => _logEvent('purchase_success');
}
