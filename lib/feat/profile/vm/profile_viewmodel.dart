import 'package:finances_control/feat/home/usecase/get_user.dart';
import 'package:finances_control/feat/profile/vm/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewModel extends Cubit<ProfileState> {
  final GetUserUseCase getUser;

  ProfileViewModel(this.getUser) : super(ProfileState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));

    try {
      final user = await getUser();
      emit(state.copyWith(status: ProfileStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }
}
