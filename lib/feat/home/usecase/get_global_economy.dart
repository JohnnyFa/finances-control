import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';

class GetGlobalEconomyUseCase {
  final TransactionRepository repository;

  GetGlobalEconomyUseCase(this.repository);

  Future<int> call() async {
    final transactions = await repository.getAll();

    int income = 0;
    int expense = 0;

    for (final tx in transactions) {
      final amount = tx.amount;

      if (tx.type == TransactionType.income) {
        income += amount;
      } else {
        expense += amount;
      }
    }

    return income - expense;
  }
}
