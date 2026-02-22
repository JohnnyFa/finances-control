import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/open_finance/domain/bank_connection.dart';

enum OpenFinanceStatus { initial, loading, success, error }

class OpenFinanceState extends Equatable {
  final OpenFinanceStatus status;
  final List<BankConnection> connections;
  final String? error;
  final String? message;

  const OpenFinanceState({
    required this.status,
    required this.connections,
    this.error,
    this.message,
  });

  factory OpenFinanceState.initial() => const OpenFinanceState(
    status: OpenFinanceStatus.initial,
    connections: [],
  );

  OpenFinanceState copyWith({
    OpenFinanceStatus? status,
    List<BankConnection>? connections,
    String? error,
    String? message,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return OpenFinanceState(
      status: status ?? this.status,
      connections: connections ?? this.connections,
      error: clearError ? null : error ?? this.error,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, connections, error, message];
}
