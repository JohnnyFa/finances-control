import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:flutter/material.dart';
import 'package:finances_control/l10n/app_localizations.dart';

extension CategoryX on Category {
  String label(AppLocalizations l10n) {
    switch (this) {
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
      case Category.utilities:
        return l10n.utilities;
      case Category.education:
        return l10n.education;
      case Category.internet:
        return l10n.internet;
      case Category.electricity:
        return l10n.electricity;
      case Category.water:
        return l10n.water;
      case Category.subscription:
        return l10n.subscription;
    }
  }

  String get emoji {
    switch (this) {
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
      case Category.utilities:
        return '🔌';
      case Category.education:
        return '🎓';
      case Category.internet:
        return '🌐';
      case Category.electricity:
        return '⚡';
      case Category.water:
        return '💧';
      case Category.subscription:
        return '💳';
    }
  }

  Color get color {
    switch (this) {
      // INCOME
      case Category.salary:
        return const Color(0xFF4CAF50); // verde
      case Category.bonus:
        return const Color(0xFF66BB6A); // verde claro
      case Category.freelance:
        return const Color(0xFF26A69A); // verde água
      case Category.investment:
        return const Color(0xFF2E7D32); // verde escuro

      // EXPENSE
      case Category.food:
        return const Color(0xFF7B3FF6); // roxo (principal)
      case Category.rent:
        return const Color(0xFF4E8CFF); // azul
      case Category.transport:
        return const Color(0xFF1E88E5); // azul escuro
      case Category.shopping:
        return const Color(0xFF8E24AA); // roxo escuro
      case Category.health:
        return const Color(0xFF26C6DA); // azul claro
      case Category.entertainment:
        return const Color(0xFF5E35B1); // roxo azulado
      case Category.others:
        return Colors.grey; // neutro
      case Category.utilities:
        return Colors.amber;
      case Category.education:
        return Colors.indigo;
      case Category.internet:
        return Colors.cyan;
      case Category.electricity:
        return Colors.yellow;
      case Category.water:
        return Colors.blue;
      case Category.subscription:
        return Colors.pink;
    }
  }

  // ───────── HELPERS ─────────

  bool get isIncome {
    return this == Category.salary ||
        this == Category.bonus ||
        this == Category.freelance ||
        this == Category.investment;
  }

  bool get isExpense => !isIncome;
}
