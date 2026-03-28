import 'package:finances_control/feat/ebooks/domain/ebook.dart';

class EbookDto {
  final Map<String, dynamic> json;

  EbookDto(this.json);

  factory EbookDto.fromJson(Map<String, dynamic> json) {
    return EbookDto(json);
  }

  Ebook toDomain() {
    return Ebook(
      title: _map(json['title']),
      author: json['author'] ?? '',
      description: _map(json['description']),
      imageUrl: json['imageUrl'] ?? '',
      buyLink: json['buyLink'] ?? '',
      category: _map(json['category']),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      price: _map(json['price']),
      isFeatured: json['isFeatured'] ?? false,
    );
  }

  Map<String, String> _map(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {};
  }
}