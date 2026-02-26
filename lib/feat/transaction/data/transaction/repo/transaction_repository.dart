import 'package:finances_control/feat/transaction/domain/transaction.dart';

abstract class TransactionRepository {
  Future<void> save(Transaction tx);
  Future<void> update(Transaction tx);
  Future<void> delete(int id);
  Future<List<Transaction>> getAll();
  Future<List<Transaction>> getByMonth({
    required int year,
    required int month,
    bool onlyExpenses = false,
  });
}
