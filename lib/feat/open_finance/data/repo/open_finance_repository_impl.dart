import 'dart:math';

import 'package:finances_control/feat/open_finance/data/dao/bank_connection_dao.dart';
import 'package:finances_control/feat/open_finance/data/dao/bank_transaction_dao.dart';
import 'package:finances_control/feat/open_finance/data/entity/bank_connection_entity.dart';
import 'package:finances_control/feat/open_finance/data/entity/bank_transaction_entity.dart';
import 'package:finances_control/feat/open_finance/data/repo/open_finance_repository.dart';
import 'package:finances_control/feat/open_finance/domain/bank_connection.dart';
import 'package:finances_control/feat/open_finance/domain/incoming_bank_payment.dart';
import 'package:finances_control/feat/transaction/data/transaction/dao/transaction_dao.dart';
import 'package:finances_control/feat/transaction/data/transaction/entity/transaction_entity.dart';

class OpenFinanceRepositoryImpl implements OpenFinanceRepository {
  final BankConnectionDao bankConnectionDao;
  final BankTransactionDao bankTransactionDao;
  final TransactionDao transactionDao;

  OpenFinanceRepositoryImpl(
    this.bankConnectionDao,
    this.bankTransactionDao,
    this.transactionDao,
  );

  @override
  Future<void> connectBank(BankConnection connection) {
    return bankConnectionDao.insert(BankConnectionEntity.fromDomain(connection));
  }

  @override
  Future<List<BankConnection>> getConnections() async {
    final data = await bankConnectionDao.findAll();
    return data.map((entity) => entity.toDomain()).toList();
  }

  @override
  Future<int> syncIncomingPayments(int bankConnectionId) async {
    final payments = _mockIncomingPayments(bankConnectionId);
    var importedCount = 0;

    for (final payment in payments) {
      final transactionExists = await transactionDao.existsByExternalId(payment.externalId);
      if (transactionExists) {
        continue;
      }

      await bankTransactionDao.insertIfNotExists(
        BankTransactionEntity(
          bankConnectionId: bankConnectionId,
          externalId: payment.externalId,
          amount: payment.amount,
          description: payment.description,
          paidAt: payment.paidAt.toIso8601String(),
          importedAt: DateTime.now().toIso8601String(),
        ),
      );

      await transactionDao.insert(
        TransactionEntity(
          amount: payment.amount,
          type: 'income',
          category: 'salary',
          date: payment.paidAt.toIso8601String(),
          description: payment.description,
          year: payment.paidAt.year,
          month: payment.paidAt.month,
          source: 'bank_sync',
          externalId: payment.externalId,
          bankConnectionId: bankConnectionId,
        ),
      );

      importedCount++;
    }

    return importedCount;
  }

  List<IncomingBankPayment> _mockIncomingPayments(int bankConnectionId) {
    final now = DateTime.now();
    final random = Random();

    return [
      IncomingBankPayment(
        externalId: 'pix-${now.year}${now.month}-$bankConnectionId',
        amount: 30000 + random.nextInt(20000),
        description: 'Automatic incoming PIX',
        paidAt: now.subtract(const Duration(hours: 1)),
      ),
      IncomingBankPayment(
        externalId: 'transfer-${now.year}${now.month}-$bankConnectionId',
        amount: 15000 + random.nextInt(10000),
        description: 'Bank transfer received',
        paidAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
