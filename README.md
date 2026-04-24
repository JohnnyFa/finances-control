# 💰 Monity - Financial Control

**Monity** is a Flutter personal finance app focused on helping users track money flow, stay on budget, and build better financial habits with a simple month-by-month workflow.

---

## 🚀 What is in the app right now

### 🧭 Main app flow
- **Start gate** that decides whether to show onboarding or jump directly to Home.
- **Onboarding** to collect core user setup:
  - name
  - monthly income
  - monthly savings goal
- **Home-first experience** with month navigation, quick access to transactions, and financial summaries.

### 📊 Home dashboard
- Monthly balance overview.
- Total income and total expenses.
- Expense chart by category (pie chart).
- Recurring transactions section integrated into monthly view.
- Pull-to-refresh support.
- Month paging (past months) with future-month blocking.

### 🧾 Transactions
- Add new transactions (income or expense).
- Edit and delete existing transactions.
- Transaction detail screen.
- Search and filter transactions.
- Grouped transaction history by month.
- CSV import for transactions with validation and user feedback.

### 🔁 Recurring transactions
- Create recurring entries with scheduling rules.
- Include recurring values in monthly calculations.
- Manage and remove recurring entries.

### 🎯 Budget control (category limits)
- Dedicated budget screen by selected month.
- Define spending limits per category.
- Visual progress of spent vs limit.
- Over-limit/within-limit status and summary metrics.
- Create, edit, and delete category limits.

### 👤 Profile and settings
- Profile overview with:
  - account info
  - financial info
  - preferences
  - about/help/privacy access
- **Account settings** (e.g., profile fields).
- **Financial settings** (income and savings goal updates).
- **Preferences**:
  - theme mode (light/dark/system)
  - notification-related toggles (UI-level preferences)
- Profile image selection support.

### 📚 E-books tab
- Separate tab for financial education content.
- E-book list loaded from Remote Config data.
- External link opening for selected materials.

### 💸 Monetization (ads + premium)
- Google Mobile Ads integration:
  - banner placements
  - interstitial usage in defined flows
  - rewarded ad gate for budget actions
- **Premium remove-ads** purchase option.
- Restore purchases support.
- Ad visibility controlled by entitlement state.

### 🌐 Internationalization
- Localized strings in:
  - English (`en`)
  - Portuguese (`pt-BR`)

### 🧱 Platform/services foundation
- Firebase Core initialization.
- Firebase Analytics app-open/event logging.
- Firebase Crashlytics error reporting.
- Firebase Remote Config integration.
- Local persistence using SQLite + SharedPreferences.
- Dependency injection via `get_it`.
- Architecture: feature-based modules using Clean Architecture + MVVM patterns.

---

## 🧪 Test and quality checks

Run locally:

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter test --coverage
```

---

## 🗺️ Current module map

- `feat/start` – app start decision flow.
- `feat/onboarding` – first-time user setup.
- `feat/home` – dashboard and monthly summary.
- `feat/transaction` – CRUD, filters, CSV import, recurring logic.
- `feat/budget_control` – category limit management.
- `feat/profile` – account/financial/preferences screens.
- `feat/ebooks` – educational content.
- `feat/ads` – ad abstractions and placements.
- `feat/premium` – in-app purchases/entitlements.
- `core/*` – navigation, theming, services, remote config, persistence, utilities.

---

## 🔬 Experimental/in-progress area

- `feat/open_finance` exists in the repository with routes, view model, repository, and local entities for bank connections/sync.
- It is currently a development module and not part of the main user-facing flow yet.
- Technical notes are documented in [`docs/bank-integration.md`](docs/bank-integration.md).
