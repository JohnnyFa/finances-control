import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';

class DeleteRecurringTransactionUseCase {
  final RecurringTransactionRepository repository;

  DeleteRecurringTransactionUseCase(this.repository);

  Future<void> call(int id) {
    return repository.delete(id);
  }
}
