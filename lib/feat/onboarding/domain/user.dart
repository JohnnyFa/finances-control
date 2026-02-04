class User {
  final String name;
  final int salary;
  final int? amountToSaveByMonth;
  final String? email;

  User({required this.name, required this.salary, this.amountToSaveByMonth, this.email});
}
