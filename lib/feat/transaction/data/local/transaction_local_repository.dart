import 'package:finances_control/feat/transaction/data/repo/transaction_dao.dart';
import 'package:finances_control/feat/transaction/data/mapper/transaction_mapper.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

import '../../domain/transaction_repository.dart';

class TransactionLocalRepository implements TransactionRepository {
  final TransactionDao dao;

  TransactionLocalRepository(this.dao);

  @override
  Future<void> save(Transaction tx) {
    return dao.insert(TransactionMapper.toEntity(tx));
  }

  @override
  Future<List<Transaction>> getAll() async {
    final data = await dao.findAll();
    return data.map(TransactionMapper.toDomain).toList();
  }
}
