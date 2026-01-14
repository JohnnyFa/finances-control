import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction_repository.dart';

class GetExpensesByMonthUseCase {
  final TransactionRepository repository;

  GetExpensesByMonthUseCase(this.repository);

  Future<List<Transaction>> call(int year, int month) {
    return repository.getByMonth(year: year, month: month, onlyExpenses: true);
  }
}
