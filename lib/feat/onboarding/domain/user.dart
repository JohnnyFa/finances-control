class User {
  final int? id;
  final String name;
  final int salary;
  final int? amountToSaveByMonth;
  final String? email;
  final String? profileImagePath;

  User({
    this.id,
    required this.name,
    required this.salary,
    this.amountToSaveByMonth,
    this.email,
    this.profileImagePath,
  });

  factory User.empty() {
    return User(
      name: '',
      salary: 0,
    );
  }

  User copyWith({
    int? id,
    String? name,
    int? salary,
    int? amountToSaveByMonth,
    String? email,
    String? profileImagePath,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      salary: salary ?? this.salary,
      amountToSaveByMonth: amountToSaveByMonth ?? this.amountToSaveByMonth,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}