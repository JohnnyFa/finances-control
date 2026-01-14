import 'package:finances_control/feat/transaction/domain/category.dart';

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
}
