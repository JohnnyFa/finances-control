import 'package:finances_control/feat/onboarding/data/entity/user_entity.dart';
import 'package:sqflite/sqlite_api.dart';

class UserDao {
  final Database db;

  UserDao(this.db);

  Future<void> insert(UserEntity user) async {
    await db.insert('user', user.toMap());
  }

  Future<void> update(UserEntity user) async {
    await db.update('user', user.toMap());
  }

  Future<void> delete() async {
    await db.delete('user');
  }

  Future<UserEntity?> get() async {
    final result = await db.query(
      'user',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UserEntity.fromMap(result.first);
  }
}
