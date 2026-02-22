class IncomingBankPayment {
  final String externalId;
  final int amount;
  final String description;
  final DateTime paidAt;

  const IncomingBankPayment({
    required this.externalId,
    required this.amount,
    required this.description,
    required this.paidAt,
  });
}
