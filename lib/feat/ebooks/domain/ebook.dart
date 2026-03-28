class Ebook {
  final Map<String, String> title;
  final String author;
  final Map<String, String> description;
  final String imageUrl;
  final String buyLink;
  final Map<String, String> category;
  final double rating;
  final Map<String, String> price;
  final bool isFeatured;

  Ebook({
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.buyLink,
    required this.category,
    required this.rating,
    required this.price,
    required this.isFeatured,
  });

  String getTitle(String locale) => title[locale] ?? title['en'] ?? '';
  String getDescription(String locale) => description[locale] ?? description['en'] ?? '';
  String getCategory(String locale) => category[locale] ?? category['en'] ?? '';
  String getPrice(String locale) => price[locale] ?? price['en'] ?? '';
}