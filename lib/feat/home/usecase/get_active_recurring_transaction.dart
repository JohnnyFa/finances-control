import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';

class GetActiveRecurringTransactionsUseCase {
  final RecurringTransactionRepository repository;

  GetActiveRecurringTransactionsUseCase(this.repository);

  Future<List<RecurringTransaction>> call() {
    return repository.getActive();
  }
}
