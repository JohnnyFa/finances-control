# 💰 Monity

**Monity** is a personal finance tracking app focused on clarity, accuracy, and real financial control.  
It helps users understand **where their money goes**, track **monthly income and expenses**, and correctly handle **recurring transactions** such as salary, rent, and subscriptions.

The app was designed from day one with **clean architecture**, **scalable structure**, and **financial precision**, avoiding common issues like floating-point rounding errors.

---

## ✨ Features

### 📊 Monthly overview
- Monthly balance calculation
- Total **income** and **expenses**
- Clear indication of positive or negative month results

### 🧾 Transactions
- Add **income** or **expense** transactions
- Categorized transactions (salary, rent, food, transport, etc.)
- Optional description
- Custom transaction date

### 🔁 Recurring transactions
- Create recurring transactions (e.g. salary every 5th, rent every 20th)
- Configure:
  - start date
  - day of month
  - optional end date
- Recurring transactions:
  - only appear in valid months
  - are automatically included in balances and charts

### 🥧 Expense distribution
- Pie chart showing expense distribution by category
- Percentage per category
- Color-coded and icon-based categories
- Automatically updates when month changes

### 📅 Month navigation
- Month / year selector
- Reloads all Home data:
  - balance
  - charts
  - active recurring transactions

### 🌍 Global economy
- Overall financial result across all months
- Clear visualization of total savings or debt

---

## 🧱 Architecture

Monity follows **Clean Architecture + MVVM**, ensuring separation of concerns, testability, and long-term maintainability.

