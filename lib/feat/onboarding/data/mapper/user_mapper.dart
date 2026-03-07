import 'package:finances_control/feat/onboarding/data/entity/user_entity.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';

class UserMapper {
  static UserEntity toEntity(User user, {int id = 0}) {
    return UserEntity(
      id: id,
      name: user.name,
      salary: user.salary,
      amountToSaveByMonth: user.amountToSaveByMonth,
      email: user.email,
      profileImagePath: user.profileImagePath,
    );
  }

  static User toDomain(UserEntity entity) {
    return User(
      id: entity.id,
      name: entity.name,
      salary: entity.salary,
      amountToSaveByMonth:
      entity.amountToSaveByMonth ?? 0,
      email: entity.email,
      profileImagePath: entity.profileImagePath,
    );
  }
}
