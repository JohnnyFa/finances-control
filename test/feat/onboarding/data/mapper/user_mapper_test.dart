import 'package:finances_control/feat/onboarding/data/entity/user_entity.dart';
import 'package:finances_control/feat/onboarding/data/mapper/user_mapper.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserMapper', () {
    test('toEntity keeps all provided values', () {
      final user = User(
        name: 'Ana',
        salary: 100000,
        amountToSaveByMonth: 20000,
        email: 'ana@test.com',
      );

      final entity = UserMapper.toEntity(user, id: 7);

      expect(entity.id, 7);
      expect(entity.name, 'Ana');
      expect(entity.salary, 100000);
      expect(entity.amountToSaveByMonth, 20000);
    });

    test('toDomain defaults null savings goal to zero', () {
      final entity = UserEntity(
        id: 1,
        name: 'Ana',
        salary: 100000,
        amountToSaveByMonth: null,
        email: 'ana@test.com',
      );

      final user = UserMapper.toDomain(entity);

      expect(user.amountToSaveByMonth, 0);
      expect(user.name, 'Ana');
    });
  });
}
