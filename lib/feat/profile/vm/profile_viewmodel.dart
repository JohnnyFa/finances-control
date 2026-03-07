import 'package:finances_control/core/services/image_service.dart';
import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';
import 'package:finances_control/feat/profile/vm/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewModel extends Cubit<ProfileState> {
  final ImageService imageService;
  final UserRepository userRepository;

  ProfileViewModel({
    required this.imageService,
    required this.userRepository,
  }) : super(ProfileState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));

    try {
      final user = await userRepository.get();
      emit(state.copyWith(status: ProfileStatus.success, user: user));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.error, error: e.toString()));
    }
  }

  Future<void> changeProfilePicture() async {
    final path = await imageService.pickProfileImage();

    if (path == null) return;

    final updatedUser = state.user.copyWith(
      profileImagePath: path,
    );

    await userRepository.update(updatedUser);

    emit(state.copyWith(user: updatedUser));
  }

}
