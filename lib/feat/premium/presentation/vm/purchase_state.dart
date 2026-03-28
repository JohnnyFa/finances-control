import 'package:equatable/equatable.dart';
import '../../domain/entitlement.dart';

abstract class PurchaseState extends Equatable {
  const PurchaseState();

  @override
  List<Object?> get props => [];
}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseSuccess extends PurchaseState {
  final Entitlement entitlement;

  const PurchaseSuccess(this.entitlement);

  @override
  List<Object?> get props => [entitlement];
}

class PurchaseError extends PurchaseState {
  final String message;

  const PurchaseError(this.message);

  @override
  List<Object?> get props => [message];
}