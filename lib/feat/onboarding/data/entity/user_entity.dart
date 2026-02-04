class UserEntity {
  final int id;
  final String name;
  final int salary;
  final String? amountToSaveByMonth;
  final String? email;

  UserEntity({
    required this.id,
    required this.name,
    required this.salary,
    this.amountToSaveByMonth,
    this.email,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'salary': salary,
    'amountToSaveByMonth': amountToSaveByMonth,
    'email': email,
  };

  factory UserEntity.fromMap(Map<String, dynamic> map) => UserEntity(
    id: map['id'] as int,
    name: map['name'] as String,
    salary: map['salary'] as int,
    amountToSaveByMonth: map['amountToSaveByMonth'] as String,
    email: map['email'] as String,
  );
}
