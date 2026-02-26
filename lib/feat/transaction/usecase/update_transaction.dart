import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<void> call(Transaction tx) {
    return repository.update(tx);
  }
}
