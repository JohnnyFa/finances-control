class User {
  final String name;
  final int salary;
  final int? amountToSaveByMonth;
  final String? email;

  User({
    required this.name,
    required this.salary,
    this.amountToSaveByMonth,
    this.email,
  });

  factory User.empty() {
    return User(name: '', email: '', salary: 0);
  }
}
