import 'package:finances_control/core/route/base/base_route_path.dart';

enum TransactionPath implements BaseRoutePath {
  transaction('transactions/transaction'),
  transactionDetail('transactions/transaction-detail');

  const TransactionPath(this.path);

  @override
  final String path;
}
