import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';

class EnumTransactionMapper {
  static Category categoryFromDb(String value) {
    return Category.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
    );
  }

  static TransactionType transactionTypeFromDb(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
    );
  }

  static String categoryToDb(Category category) {
    return category.name;
  }

  static String transactionTypeToDb(TransactionType type) {
    return type.name;
  }
}
