import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';

String transactionTypeLabel(BuildContext context, TransactionType type) {
  final l10n = AppLocalizations.of(context)!;

  switch (type) {
    case TransactionType.income:
      return '💰 ${l10n.income}';
    case TransactionType.expense:
      return '💸 ${l10n.expense}';
  }
}

String categoryLabel(BuildContext context, Category category) {
  final l10n = AppLocalizations.of(context)!;

  switch (category) {
    case Category.salary:
      return l10n.salary;
    case Category.bonus:
      return l10n.bonus;
    case Category.freelance:
      return l10n.freelance;
    case Category.investment:
      return l10n.investment;
    case Category.food:
      return l10n.food;
    case Category.transport:
      return l10n.transport;
    case Category.rent:
      return l10n.rent;
    case Category.shopping:
      return l10n.shopping;
    case Category.health:
      return l10n.health;
    case Category.entertainment:
      return l10n.entertainment;
    case Category.others:
      return l10n.others;
  }
}

String categoryEmoji(BuildContext context, Category category) {
  switch (category) {
    case Category.salary:
      return '💼';
    case Category.bonus:
      return '🎁';
    case Category.freelance:
      return '🧑‍💻';
    case Category.investment:
      return '📈';
    case Category.food:
      return '🍔';
    case Category.transport:
      return '🚗';
    case Category.rent:
      return '🏠';
    case Category.shopping:
      return '🛍️';
    case Category.health:
      return '🏥';
    case Category.entertainment:
      return '🎮';
    case Category.others:
      return '📦';
  }
}
