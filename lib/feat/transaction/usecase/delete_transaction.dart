import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository repository;

  DeleteTransactionUseCase(this.repository);

  Future<void> call(int id) {
    return repository.delete(id);
  }
}
