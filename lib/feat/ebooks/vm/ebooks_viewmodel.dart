import 'package:finances_control/feat/ebooks/data/repo/ebooks_repository.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EbooksViewModel extends Cubit<EbooksState> {
  final EbooksRepository repository;

  EbooksViewModel(this.repository) : super(EbooksInitial());

  Future<void> load() async {
    emit(EbooksLoading());

    try {
      final ebooks = await repository.getEbooks();
      emit(EbooksLoaded(ebooks));
    } catch (e) {
      emit(EbooksError(e.toString()));
    }
  }
}
