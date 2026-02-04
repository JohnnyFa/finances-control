import 'package:finances_control/feat/onboarding/data/entity/user_entity.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';

class UserMapper {
  static UserEntity toEntity(User user, {int id = 0}) {
    return UserEntity(
      id: id,
      name: user.name,
      salary: user.salary,
      amountToSaveByMonth: user.amountToSaveByMonth?.toString(),
      email: user.email,
    );
  }

  static User toDomain(UserEntity entity) {
    return User(
      name: entity.name,
      salary: entity.salary,
      amountToSaveByMonth:
      entity.amountToSaveByMonth != null
          ? int.tryParse(entity.amountToSaveByMonth!)
          : null,
      email: entity.email,
    );
  }
}
