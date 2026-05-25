# Monity AI Agent Guide

## Architecture Overview
Monity follows **Clean Architecture + MVVM** with feature-based organization:
- `lib/core/`: Shared services, DB, DI, themes, routes
- `lib/feat/{feature}/`: Feature modules with `domain/`, `usecase/`, `data/`, `viewmodel/`, `ui/`, `di/`, `route/`
- State management via `flutter_bloc` (Cubit pattern) with `BlocProvider` per page
- Dependency injection using `get_it` (see `core/di/setup_locator.dart`)

## Key Patterns
- **Feature Structure**: Each feature encapsulates domain logic, usecases, viewmodels, and UI
- **Domain Layer**: Plain Dart entities with business logic (e.g., `feat/home/domain/home_calculator.dart`)
- **Usecases**: Single-responsibility classes wrapping repository calls, injected via `get_it`
- **ViewModels**: BLoC Cubits for UI state (e.g., `feat/home/viewmodel/home_viewmodel.dart`)
- **Navigation**: Centralized routes in `core/route/app_navigation.dart` with `BlocProvider` wrappers
- **Database**: SQLite via `sqflite` with migrations in `core/db/database_helper.dart`

---

## Task Execution Guidelines

Follow this checklist **on every task**, top to bottom. Every layer must be implemented together — never deliver a partial slice.

### 1. Domain (`feat/{feature}/domain/`)
- Create plain Dart entity class with all fields and computed properties
- Use `copyWith` when the entity will be mutated from the UI
- No Flutter imports — pure Dart only
- Example: `feat/budget_control/domain/budget.dart`

### 2. Repository Interface (`feat/{feature}/data/repo/{feature}_repository.dart`)
- Abstract class with typed method signatures
- No implementation details — just the contract
- Example:
  ```dart
  abstract class BudgetRepository {
    Future<List<Budget>> getBudgetsByMonth(int month, int year);
    Future<void> upsertBudget(String categoryId, int month, int year, int limitCents);
    Future<void> deleteBudget(String categoryId, int month, int year);
  }
  ```

### 3. Repository Implementation (`feat/{feature}/data/repo/{feature}_repository_impl.dart`)
- `class FooRepositoryImpl implements FooRepository`
- Receives `Database` (or other data source) via constructor injection
- Maps between DB entities and domain models
- Example: `feat/budget_control/data/repo/budget_repository_impl.dart`

### 4. Usecase (`feat/{feature}/usecase/{action}.dart`)
- One class per action, single `call()` method
- Receives repository via constructor
- Example:
  ```dart
  class GetBudgetsByMonthUseCase {
    final BudgetRepository repository;
    GetBudgetsByMonthUseCase(this.repository);
    Future<List<Budget>> call(int month, int year) =>
        repository.getBudgetsByMonth(month, year);
  }
  ```

### 5. State (`feat/{feature}/viewmodel/{feature}_state.dart`)
- `abstract class FooState extends Equatable`
- Concrete states: `FooInitial`, `FooLoading`, `FooLoaded`, `FooError`
- `FooLoaded` holds all display-ready data and computed getters
- Always override `props` for equality
- Example: `feat/budget_control/vm/budget_state.dart`

### 6. ViewModel / Cubit (`feat/{feature}/viewmodel/{feature}_viewmodel.dart`)
- `class FooViewModel extends Cubit<FooState>`
- Constructor receives repositories or usecases (never raw `Database`)
- Pattern: `emit(FooLoading())` → `try/catch` → `emit(FooLoaded(...))` / `emit(FooError(...))`
- Example: `feat/budget_control/vm/budget_viewmodel.dart`

### 7. DI Registration (`feat/{feature}/di/{feature}_injection.dart`)
- `void fooInjection()` function
- Register abstract type → concrete impl as `registerLazySingleton`
- Register ViewModel as `registerFactory` (one instance per page)
- Register usecases per their scope (singleton or factory)
- Call from `core/di/setup_locator.dart`
- Example: `feat/budget_control/di/budget_injection.dart`

### 8. Route / Navigation (`feat/{feature}/route/`)
- `{feature}_path.dart`: path constants as enum or class
- `{feature}_navigation.dart`: `WidgetBuilder` map with `BlocProvider` wrapping
- Register in `core/route/app_navigation.dart`

### 9. UI (`feat/{feature}/ui/`)
- **Page**: `StatefulWidget`, reads cubit from `context.read<>()`, calls `load()` in `initState`
- **BlocBuilder**: wraps state-dependent subtrees, pattern-matches on concrete states
- **Sub-widgets**: extract to private `_WidgetName` classes or `components/` subfolder
- Use `context.appStrings` for all user-facing strings (never hardcode)
- Use `Theme.of(context).colorScheme` for all colors
- Example: `feat/budget_control/ui/budget_page.dart`

---

## Unit Test Guidelines

### File Location
Mirror `lib/` structure under `test/`:
```
test/feat/{feature}/viewmodel/{feature}_viewmodel_test.dart
test/feat/{feature}/domain/{entity}_test.dart
test/feat/{feature}/data/repo/{feature}_repository_impl_test.dart
```

### Packages
- `flutter_test` — test runner
- `mocktail` — mock generation (use `Mock implements`, never `mockito`)
- `bloc_test` — for Cubit state sequence assertions (optional but preferred)

### Mocking Pattern
Declare mock classes at the bottom of the file:
```dart
class _MockBudgetRepository extends Mock implements BudgetRepository {}
```

### ViewModel Test Structure
```dart
void main() {
  late _MockFooRepository repository;
  late FooViewModel viewModel;

  setUp(() {
    repository = _MockFooRepository();
    viewModel = FooViewModel(repository);
  });

  tearDown(() async => viewModel.close());

  test('successful load emits loading then loaded', () async {
    when(() => repository.getAll()).thenAnswer((_) async => [...]);

    final states = expectLater(
      viewModel.stream,
      emitsInOrder([isA<FooLoading>(), isA<FooLoaded>()]),
    );

    await viewModel.load();
    await states;
  });

  test('error emits loading then error', () async {
    when(() => repository.getAll()).thenThrow(Exception('boom'));

    final states = expectLater(
      viewModel.stream,
      emitsInOrder([isA<FooLoading>(), isA<FooError>()]),
    );

    await viewModel.load();
    await states;
  });
}
```

### Domain / Pure Logic Tests
No mocks needed — instantiate entity directly and assert computed properties:
```dart
test('isOverBudget when spent > limit', () {
  final budget = Budget(limitCents: 100, spentCents: 150, ...);
  expect(budget.isOverBudget, isTrue);
});
```

### Widget Test Helper
Use `pumpApp` from `test/helpers/pump_widget.dart` to wrap widgets with localization + Material:
```dart
await tester.pumpApp(MyWidget());
```

### Test Checklist per Feature
- [ ] Domain entity computed properties
- [ ] ViewModel: happy path (loading → loaded)
- [ ] ViewModel: error path (loading → error)
- [ ] ViewModel: edge cases (empty list, boundary values)
- [ ] Repository impl (if complex SQL / mapping logic)

---

## Developer Workflows
- **Setup**: `flutter pub get && flutter gen-l10n`
- **Test**: `flutter test --coverage` (CI runs on push/PR via `.github/workflows/test_suite.yml`)
- **Analyze**: `flutter analyze` (uses `flutter_lints`)
- **Build**: Use `main_dev.dart` or `main_prod.dart` for flavors (dev/prod via `core/flavor/app_flavor.dart`)
- **Localization**: `flutter gen-l10n` for `l10n/` strings

## Conventions
- **Themes**: Material 3 with light/dark modes (see `core/theme/app_theme.dart`)
- **Error Handling**: Crashlytics integration in `main.dart` for unhandled errors
- **Logging**: Custom logger in `core/logger/app_logger.dart`
- **Remote Config**: Firebase Remote Config for feature flags (see `core/remote_config/`)
- **Ads**: Google Mobile Ads initialized in `main.dart`
- **Purchases**: In-app purchases via `feat/premium/presentation/init/purchase_initializer.dart`
- **Equatable**: All state classes must use `equatable` and override `props`
- **No hardcoded strings**: Always use `context.appStrings` (generated by `flutter gen-l10n`)
- **No hardcoded colors**: Always use `Theme.of(context).colorScheme`

## External Integrations
- **Firebase**: Analytics, Crashlytics, Remote Config, Messaging, In-App Messaging
- **Bank Sync**: Planned provider adapter pattern (see `docs/bank-integration.md`) for Open Finance
- **Charts**: `fl_chart` for expense distribution pies
- **Formatting**: `flutter_multi_formatter` for currency inputs

## Key Files
- `pubspec.yaml`: Dependencies and assets
- `lib/main.dart`: App initialization with Firebase, DI, themes
- `lib/core/di/setup_locator.dart`: Service registrations (call `{feature}Injection()` here)
- `lib/feat/home/`: Full reference feature implementation
- `lib/feat/budget_control/`: Another complete feature (repo + VM + UI + tests)
- `analysis_options.yaml`: Linting rules

---

## Available Skills

Use these Claude Code skills during relevant tasks:

| Skill | When to invoke |
|---|---|
| `/run` | After implementing UI changes — starts the app and verifies the feature works |
| `/verify` | Confirm a fix or PR change works end-to-end before marking done |
| `/code-review` | Review the current diff for correctness bugs before committing |
| `/security-review` | Run before any auth, DB, or network-facing change |
| `/init` | Re-generate CLAUDE.md documentation after large structural changes |
