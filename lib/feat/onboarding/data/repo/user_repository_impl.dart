import 'package:finances_control/feat/onboarding/data/dao/user_dao.dart';
import 'package:finances_control/feat/onboarding/data/mapper/user_mapper.dart';
import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDao dao;

  UserRepositoryImpl(this.dao);

  @override
  Future<void> save(User user) async {
    final entity = UserMapper.toEntity(user);
    await dao.insert(entity);
  }

  @override
  Future<void> update(User user) async {
    final entity = UserMapper.toEntity(user);
    await dao.update(entity);
  }

  @override
  Future<void> delete() async {
    await dao.delete();
  }

  @override
  Future<User> get() async {
    final entity = await dao.get();

    if (entity == null) {
      throw Exception('User not found');
    }

    return UserMapper.toDomain(entity);
  }

  @override
  Future<bool> exists() async {
    final entity = await dao.get();
    return entity != null;
  }
}