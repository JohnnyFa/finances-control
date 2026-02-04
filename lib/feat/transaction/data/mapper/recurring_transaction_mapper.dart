import 'package:finances_control/feat/transaction/data/recurring/entity/recurring_transaction_entity.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';

class RecurringTransactionMapper {
  static RecurringTransactionEntity toEntity(
      RecurringTransaction rt,
      ) {
    return RecurringTransactionEntity(
      id: rt.id,
      amount: rt.amount,
      type: rt.type.name,
      category: rt.category.name,
      dayOfMonth: rt.dayOfMonth,
      startDate: rt.startDate.toIso8601String(),
      description: rt.description,
      active: rt.active ? 1 : 0,
      endDate: rt.endDate != null ? rt.endDate?.toIso8601String() : "",
    );
  }

  static RecurringTransaction toDomain(
      RecurringTransactionEntity e,
      ) {
    return RecurringTransaction(
      id: e.id,
      amount: e.amount,
      type: TransactionType.values.firstWhere(
            (t) => t.name == e.type,
      ),
      category: Category.values.firstWhere(
            (c) => c.name == e.category,
      ),
      dayOfMonth: e.dayOfMonth,
      startDate: DateTime.parse(e.startDate),
      description: e.description ?? '',
      active: e.active == 1,
    );
  }
}
