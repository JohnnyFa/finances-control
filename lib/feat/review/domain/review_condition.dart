class ReviewCondition {
  final int entryCount;
  final int transactionCount;
  final int csvImportCount;
  final bool reviewRequested;

  const ReviewCondition({
    required this.entryCount,
    required this.transactionCount,
    required this.csvImportCount,
    required this.reviewRequested,
  });

  bool get isMet =>
      !reviewRequested &&
      entryCount >= 5 &&
      transactionCount >= 3 &&
      csvImportCount >= 1;
}
