import '../../../domain/recurring_transaction.dart';

abstract class RecurringTransactionRepository {
  Future<void> save(RecurringTransaction rt);
  Future<void> delete(int id);
  Future<List<RecurringTransaction>> getAll();
  Future<List<RecurringTransaction>> getActive();

}
