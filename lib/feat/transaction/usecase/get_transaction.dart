import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;
  final RecurringTransactionRepository recurringRepository;

  GetTransactionsUseCase(
      this.repository,
      this.recurringRepository,
      );

  Future<List<Transaction>> call() async {
    final transactions = await repository.getAll();
    final recurring = await recurringRepository.getAll();

    final generated = _generateRecurringTransactions(recurring);

    return [...transactions, ...generated]
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Transaction> _generateRecurringTransactions(
      List<RecurringTransaction> recurring,
      ) {
    final now = DateTime.now();
    final generated = <Transaction>[];

    for (final r in recurring) {
      if (!r.active) continue;

      final start = r.startDate;
      final end = r.endDate ?? now;

      DateTime current = DateTime(start.year, start.month, r.dayOfMonth);

      while (!current.isAfter(end)) {
        if (!current.isAfter(now)) {
          generated.add(
            Transaction(
              id: r.id,
              amount: r.amount,
              type: r.type,
              category: r.category,
              description: r.description,
              date: current,
              isGenerated: true,
            ),
          );
        }

        current = DateTime(current.year, current.month + 1, r.dayOfMonth);
      }
    }

    return generated;
  }
}