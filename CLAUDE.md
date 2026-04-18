# Monity AI Agent Guide

## Architecture Overview
Monity follows **Clean Architecture + MVVM** with feature-based organization:
- `lib/core/`: Shared services, DB, DI, themes, routes
- `lib/feat/{feature}/`: Feature modules with `domain/`, `usecase/`, `viewmodel/`, `ui/`, `di/`, `route/`
- State management via `flutter_bloc` with `BlocProvider` per page
- Dependency injection using `get_it` (see `core/di/setup_locator.dart`)

## Key Patterns
- **Feature Structure**: Each feature (e.g., `feat/home/`) encapsulates domain logic, usecases, viewmodels, and UI
- **Domain Layer**: Entities and business rules (e.g., `feat/home/domain/home_calculator.dart`)
- **Usecases**: Application logic injected via `get_it` (e.g., `feat/home/usecase/get_expenses_by_month.dart`)
- **ViewModels**: BLoC cubits for UI state (e.g., `feat/home/viewmodel/home_viewmodel.dart`)
- **Navigation**: Centralized routes in `core/route/app_navigation.dart` with `BlocProvider` wrappers
- **Database**: SQLite via `sqflite` with migrations in `core/db/database_helper.dart` (tables: transactions, recurring_transactions, users, bank_connections)

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

## External Integrations
- **Firebase**: Analytics, Crashlytics, Remote Config, Messaging, In-App Messaging
- **Bank Sync**: Planned provider adapter pattern (see `docs/bank-integration.md`) for Open Finance
- **Charts**: `fl_chart` for expense distribution pies
- **Formatting**: `flutter_multi_formatter` for currency inputs

## Key Files
- `pubspec.yaml`: Dependencies and assets
- `lib/main.dart`: App initialization with Firebase, DI, themes
- `lib/core/di/setup_locator.dart`: Service registrations
- `lib/feat/home/`: Example feature implementation
- `analysis_options.yaml`: Linting rules
