import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction_rules.dart';

class GetGlobalEconomyUseCase {
  final TransactionRepository repository;
  final RecurringTransactionRepository recurringRepository;

  GetGlobalEconomyUseCase(this.repository, this.recurringRepository);

  Future<int> call() async {
    final transactions = await repository.getAll();
    final recurring = await recurringRepository.getAll();

    int income = 0;
    int expense = 0;

    for (final tx in transactions) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    final now = DateTime.now();

    for (final rt in recurring) {
      // Calculate how many months this recurring transaction has been active
      // from its start date until now (inclusive of current month if applicable)

      int currentYear = rt.startDate.year;
      int currentMonth = rt.startDate.month;

      while (true) {
        if (currentYear > now.year ||
            (currentYear == now.year && currentMonth > now.month)) {
          break;
        }

        if (isActiveForMonth(rt, currentYear, currentMonth)) {
          if (rt.type == TransactionType.income) {
            income += rt.amount;
          } else {
            expense += rt.amount;
          }
        }

        currentMonth++;
        if (currentMonth > 12) {
          currentMonth = 1;
          currentYear++;
        }
      }
    }

    return income - expense;
  }
}
