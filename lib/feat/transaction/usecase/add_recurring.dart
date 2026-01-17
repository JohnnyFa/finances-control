import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction_repository.dart';

class AddRecurringTransactionUseCase {
  final RecurringTransactionRepository repository;

  AddRecurringTransactionUseCase(this.repository);

  Future<void> call(RecurringTransaction rt) {
    return repository.save(rt);
  }
}
