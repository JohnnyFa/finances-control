import 'package:finances_control/feat/transaction/data/mapper/recurring_transaction_mapper.dart';
import 'package:finances_control/feat/transaction/data/recurring/dao/recurring_transaction_dao.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';

class RecurringTransactionRepositoryImpl
    implements RecurringTransactionRepository {
  final RecurringTransactionDao dao;

  RecurringTransactionRepositoryImpl(this.dao);

  @override
  Future<void> save(RecurringTransaction rt) {
    return dao.insert(RecurringTransactionMapper.toEntity(rt));
  }

  @override
  Future<List<RecurringTransaction>> getAll() async {
    final data = await dao.findAll();
    return data.map(RecurringTransactionMapper.toDomain).toList();
  }

  @override
  Future<List<RecurringTransaction>> getActive() async {
    final data = await dao.findActive();
    return data.map(RecurringTransactionMapper.toDomain).toList();
  }
}
