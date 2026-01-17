import 'recurring_transaction.dart';

abstract class RecurringTransactionRepository {
  Future<void> save(RecurringTransaction rt);
  Future<List<RecurringTransaction>> getAll();
  Future<List<RecurringTransaction>> getActive();
}
