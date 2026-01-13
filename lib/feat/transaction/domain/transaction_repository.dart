import 'package:finances_control/feat/transaction/domain/transaction.dart';

abstract class TransactionRepository {
  Future<void> save(Transaction tx);
  Future<List<Transaction>> getAll();
}
