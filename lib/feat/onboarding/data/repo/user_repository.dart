import 'package:finances_control/feat/onboarding/domain/user.dart';

abstract class UserRepository {
  Future<void> save(User user);
  Future<void> update(User user);
  Future<void> delete();
  Future<User> get();
  Future<bool> exists();
}
