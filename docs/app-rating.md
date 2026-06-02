# App Rating — Implementation Guide

Request an in-app store review after the user has demonstrated genuine engagement, without interrupting their flow.

---

## Trigger Conditions

All three counters must be satisfied simultaneously before the prompt is shown:

| Counter | Threshold | Incremented by |
|---|---|---|
| `entryCount` | ≥ 5 | Any manual entry added (transaction or recurring) |
| `transactionCount` | ≥ 3 | One-time transaction saved via `TransactionViewModel.add()` |
| `csvImportCount` | ≥ 1 | Successful CSV import via `TransactionViewModel.importCsv()` |

The prompt is shown **only once, only from `HomePage`**. After it fires, a `reviewRequested` flag is persisted so it never fires again, regardless of future counter values.

---

## Package

```yaml
# pubspec.yaml
dependencies:
  in_app_review: ^2.0.9
```

- Android: Google Play In-App Review API (native bottom sheet, no redirect)
- iOS: StoreKit `SKStoreReviewController.requestReview()` (native prompt)
- Both: availability is not guaranteed — the OS decides whether to actually show the dialog

---

## Architecture

Follows the project's Clean Architecture + MVVM pattern. Lives under `lib/feat/review/`.

```
lib/feat/review/
  domain/
    review_condition.dart          ← pure entity, holds counters + isMet getter
  data/
    repo/
      review_repository.dart       ← abstract contract
      review_repository_impl.dart  ← SharedPreferences-backed implementation
  usecase/
    check_review_condition.dart
    increment_entry_count.dart
    increment_transaction_count.dart
    mark_csv_uploaded.dart
  service/
    review_service.dart            ← wraps in_app_review plugin
  di/
    review_injection.dart
```

---

## 1. Domain Entity

```dart
// lib/feat/review/domain/review_condition.dart
class ReviewCondition {
  final int entryCount;
  final int transactionCount;
  final int csvImportCount;
  final bool reviewRequested;

  const ReviewCondition({
    required this.entryCount,
    required this.transactionCount,
    required this.csvImportCount,
    required this.reviewRequested,
  });

  bool get isMet =>
      !reviewRequested &&
      entryCount >= 5 &&
      transactionCount >= 3 &&
      csvImportCount >= 1;
}
```

No `Equatable` needed here — this is a read model, not a BLoC state.

---

## 2. Repository Interface

```dart
// lib/feat/review/data/repo/review_repository.dart
abstract class ReviewRepository {
  Future<ReviewCondition> getCondition();
  Future<void> incrementEntryCount();
  Future<void> incrementTransactionCount();
  Future<void> incrementCsvImportCount();
  Future<void> markReviewRequested();
}
```

---

## 3. Repository Implementation

Uses `SharedPreferences` — no DB migration needed.

```dart
// lib/feat/review/data/repo/review_repository_impl.dart
import 'package:shared_preferences/shared_preferences.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  static const _keyEntry       = 'review_entry_count';
  static const _keyTransaction = 'review_transaction_count';
  static const _keyCsv         = 'review_csv_import_count';
  static const _keyRequested   = 'review_requested';

  @override
  Future<ReviewCondition> getCondition() async {
    final prefs = await SharedPreferences.getInstance();
    return ReviewCondition(
      entryCount:       prefs.getInt(_keyEntry) ?? 0,
      transactionCount: prefs.getInt(_keyTransaction) ?? 0,
      csvImportCount:   prefs.getInt(_keyCsv) ?? 0,
      reviewRequested:  prefs.getBool(_keyRequested) ?? false,
    );
  }

  @override
  Future<void> incrementEntryCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyEntry, (prefs.getInt(_keyEntry) ?? 0) + 1);
  }

  @override
  Future<void> incrementTransactionCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _keyTransaction,
      (prefs.getInt(_keyTransaction) ?? 0) + 1,
    );
  }

  @override
  Future<void> incrementCsvImportCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCsv, (prefs.getInt(_keyCsv) ?? 0) + 1);
  }

  @override
  Future<void> markReviewRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRequested, true);
  }
}
```

---

## 4. Usecases

```dart
// lib/feat/review/usecase/check_review_condition.dart
class CheckReviewConditionUseCase {
  final ReviewRepository repository;
  CheckReviewConditionUseCase(this.repository);
  Future<ReviewCondition> call() => repository.getCondition();
}

// lib/feat/review/usecase/increment_entry_count.dart
class IncrementEntryCountUseCase {
  final ReviewRepository repository;
  IncrementEntryCountUseCase(this.repository);
  Future<void> call() => repository.incrementEntryCount();
}

// lib/feat/review/usecase/increment_transaction_count.dart
class IncrementTransactionCountUseCase {
  final ReviewRepository repository;
  IncrementTransactionCountUseCase(this.repository);
  Future<void> call() => repository.incrementTransactionCount();
}

// lib/feat/review/usecase/mark_csv_uploaded.dart
class MarkCsvUploadedUseCase {
  final ReviewRepository repository;
  MarkCsvUploadedUseCase(this.repository);
  Future<void> call() => repository.incrementCsvImportCount();
}
```

---

## 5. Review Service

```dart
// lib/feat/review/service/review_service.dart
import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  final InAppReview _inAppReview;

  ReviewService({InAppReview? inAppReview})
      : _inAppReview = inAppReview ?? InAppReview.instance;

  Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }
}
```

Wrapping the plugin in a service makes it injectable and mockable in tests.

---

## 6. DI Registration

```dart
// lib/feat/review/di/review_injection.dart
void reviewInjection() {
  getIt.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(),
  );
  getIt.registerLazySingleton(() => ReviewService());
  getIt.registerLazySingleton(
    () => CheckReviewConditionUseCase(getIt<ReviewRepository>()),
  );
  getIt.registerLazySingleton(
    () => IncrementEntryCountUseCase(getIt<ReviewRepository>()),
  );
  getIt.registerLazySingleton(
    () => IncrementTransactionCountUseCase(getIt<ReviewRepository>()),
  );
  getIt.registerLazySingleton(
    () => MarkCsvUploadedUseCase(getIt<ReviewRepository>()),
  );
}
```

Call `reviewInjection()` from `lib/core/di/setup_locator.dart` alongside the other feature injections.

---

## 7. Integration Points

### 7a. `PreferencesKeys` — add new keys (optional, for consistency)

```dart
// lib/core/shared_preferences/preferences_keys.dart
abstract class PreferencesKeys {
  // ... existing keys ...
  static const reviewEntryCount       = 'review_entry_count';
  static const reviewTransactionCount = 'review_transaction_count';
  static const reviewCsvImportCount   = 'review_csv_import_count';
  static const reviewRequested        = 'review_requested';
}
```

Update `ReviewRepositoryImpl` to use these constants to avoid typo drift.

### 7b. `TransactionViewModel` — increment counters after success

Inject the three usecases into `TransactionViewModel` and call them after each successful operation:

```dart
// Inside add() — after addUseCase(tx) succeeds:
await incrementTransactionCountUseCase();
await incrementEntryCountUseCase();

// Inside addRecurring() — after addRecurringUseCase(rt) succeeds:
await incrementEntryCountUseCase();

// Inside importCsv() — after importCsvUseCase() succeeds:
await markCsvUploadedUseCase();
```

Register the new usecases in `TransactionInjection` and pass them through the constructor.

### 7c. `HomePage` — trigger the review prompt

After `HomeLoaded` is first emitted, check the condition and fire the prompt if met:

```dart
// Inside _HomeTransactionsTabState.initState():
WidgetsBinding.instance.addPostFrameCallback((_) {
  _checkAndRequestReview();
});

Future<void> _checkAndRequestReview() async {
  final checkUseCase = getIt<CheckReviewConditionUseCase>();
  final reviewService = getIt<ReviewService>();
  final reviewRepo    = getIt<ReviewRepository>();

  final condition = await checkUseCase();
  if (!condition.isMet) return;

  await reviewService.requestReview();
  await reviewRepo.markReviewRequested();
}
```

`addPostFrameCallback` ensures the page is fully built before the prompt is triggered. The check is lightweight (SharedPreferences read) so it won't block rendering.

---

## 8. Testing

### Domain

```dart
test('isMet when all thresholds reached and not yet requested', () {
  final c = ReviewCondition(
    entryCount: 5, transactionCount: 3, csvImportCount: 1,
    reviewRequested: false,
  );
  expect(c.isMet, isTrue);
});

test('isMet is false when reviewRequested is true', () {
  final c = ReviewCondition(
    entryCount: 10, transactionCount: 10, csvImportCount: 10,
    reviewRequested: true,
  );
  expect(c.isMet, isFalse);
});

test('isMet is false when any counter below threshold', () {
  final c = ReviewCondition(
    entryCount: 4, transactionCount: 3, csvImportCount: 1,
    reviewRequested: false,
  );
  expect(c.isMet, isFalse);
});
```

### Repository

Use `shared_preferences` test package (`SharedPreferences.setMockInitialValues({})`) to test `ReviewRepositoryImpl` in isolation.

### `ReviewService`

Mock `InAppReview` to assert `requestReview()` is called only when `isAvailable()` returns true.

---

## Platform Notes

| Platform | Behavior |
|---|---|
| Android | Google Play bottom sheet; requires app published to a track the device has access to |
| iOS | StoreKit native dialog; rate-limited by OS (may be silently suppressed) |
| Both | The OS may suppress the dialog even if `requestReview()` is called — this is by design |

**Do not redirect to the store manually** unless the OS suppressed the prompt and you want a fallback. The `in_app_review` package handles this automatically via `openStoreListing()` if needed.
