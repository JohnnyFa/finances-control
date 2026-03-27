import 'package:finances_control/feat/ebooks/domain/ebook.dart';

sealed class EbooksState {}

class EbooksInitial extends EbooksState {}

class EbooksLoading extends EbooksState {}

class EbooksLoaded extends EbooksState {
  final List<Ebook> ebooks;

  EbooksLoaded(this.ebooks);
}

class EbooksError extends EbooksState {
  final String message;

  EbooksError(this.message);
}
