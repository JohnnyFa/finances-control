import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';

class HasUserUseCase {
  final UserRepository repository;

  HasUserUseCase(this.repository);

  Future<bool> call() async {
    return repository.exists();
  }
}
