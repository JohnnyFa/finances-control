import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:flutter/material.dart';

extension CategoryX on Category {
  String get label {
    switch (this) {
      case Category.salary:
        return '💼 Salary';
      case Category.bonus:
        return '🎁 Bonus';
      case Category.freelance:
        return '🧑‍💻 Freelance';
      case Category.investment:
        return '📈 Investment';

      case Category.food:
        return '🍔 Food';
      case Category.transport:
        return '🚗 Transport';
      case Category.rent:
        return '🏠 Rent';
      case Category.shopping:
        return '🛍️ Shopping';
      case Category.health:
        return '🏥 Health';
      case Category.entertainment:
        return '🎮 Entertainment';

      case Category.others:
        return '📦 Others';
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
        return const Color(0xFF43A047); // verde
      case Category.shopping:
        return const Color(0xFF8E24AA); // roxo escuro
      case Category.health:
        return const Color(0xFF26C6DA); // azul claro
      case Category.entertainment:
        return const Color(0xFF5E35B1); // roxo azulado
      case Category.others:
        return Colors.grey; // neutro
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
