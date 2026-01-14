import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'category.dart';

const Map<TransactionType, List<Category>> categoryByType = {
  TransactionType.income: [
    Category.salary,
    Category.bonus,
    Category.freelance,
    Category.investment,
    Category.others,
  ],
  TransactionType.expense: [
    Category.food,
    Category.transport,
    Category.rent,
    Category.shopping,
    Category.health,
    Category.entertainment,
    Category.others,
  ],
};
