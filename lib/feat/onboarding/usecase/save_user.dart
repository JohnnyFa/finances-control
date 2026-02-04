
import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';

class SaveUserUseCase {
  final UserRepository repository;

  SaveUserUseCase(this.repository);

  Future<void> call(User user) {
    return repository.save(user);
  }
}
