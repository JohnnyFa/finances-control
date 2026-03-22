class CategoryBudgetEntity {
  final int? id;
  final String categoryId;
  final int month;
  final int year;
  final int limitCents;
  final String? createdAt;
  final String? updatedAt;

  CategoryBudgetEntity({
    this.id,
    required this.categoryId,
    required this.month,
    required this.year,
    required this.limitCents,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'month': month,
      'year': year,
      'limit_cents': limitCents,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  factory CategoryBudgetEntity.fromMap(Map<String, dynamic> map) {
    return CategoryBudgetEntity(
      id: map['id'],
      categoryId: map['category_id'],
      month: map['month'],
      year: map['year'],
      limitCents: map['limit_cents'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}
