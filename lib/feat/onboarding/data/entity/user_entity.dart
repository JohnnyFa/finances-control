class UserEntity {
  final int id;
  final String name;
  final int salary;
  final int? amountToSaveByMonth;
  final String? email;
  final String? profileImagePath;

  UserEntity({
    required this.id,
    required this.name,
    required this.salary,
    this.amountToSaveByMonth,
    this.email,
    this.profileImagePath,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'salary': salary,
    'amountToSaveByMonth': amountToSaveByMonth,
    'email': email,
    'profileImagePath': profileImagePath,
  };

  factory UserEntity.fromMap(Map<String, dynamic> map) => UserEntity(
    id: map['id'],
    name: map['name'],
    salary: map['salary'],
    amountToSaveByMonth: map['amountToSaveByMonth'],
    email: map['email'],
    profileImagePath: map['profileImagePath'],
  );
}