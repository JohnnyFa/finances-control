import 'package:finances_control/feat/transaction/domain/category.dart';

class CategoryDetector {
  static Category detect(String description) {
    final text = description.toLowerCase();

    /// FOOD / RESTAURANTS
    if (_containsAny(text, [
      'restaurant',
      'restaurante',
      'pizza',
      'pizzaria',
      'burger',
      'hamburguer',
      'lanch',
      'lanche',
      'ifood',
      'ifd',
      'apetit',
      'panificadora',
      'padaria',
      'confeit',
      'cafe',
      'cafeteria',
      'coffee',
      'bar',
      'bebidas',
      'drink',
      'mcdonald',
      'bk',
      'subway',
      'kfc',
      'habibs',
      'outback',
      'starbucks'
    ])) {
      return Category.food;
    }

    /// SUPERMARKETS / GROCERIES
    if (_containsAny(text, [
      'supermercado',
      'mercado',
      'market',
      'preco',
      'carrefour',
      'extra',
      'assai',
      'atacadao',
      'dia',
      'big',
      'pao de acucar',
      'condor',
      'zaffari',
      'walmart',
      'costco',
      'sam',
      'club',
    ])) {
      return Category.food;
    }

    /// SHOPPING / RETAIL
    if (_containsAny(text, [
      'amazon',
      'amazonmktplc',
      'mercado livre',
      'shopee',
      'magalu',
      'magazineluiza',
      'americanas',
      'submarino',
      'aliexpress',
      'shein',
      'store',
      'loja',
      'shopping',
      'centauro',
      'nike',
      'adidas',
      'renner',
      'riachuelo',
      'c&a',
      'h&m'
    ])) {
      return Category.shopping;
    }

    /// ENTERTAINMENT / SUBSCRIPTIONS
    if (_containsAny(text, [
      'netflix',
      'spotify',
      'prime',
      'amazon prime',
      'youtube',
      'youtube premium',
      'disney',
      'disneyplus',
      'hbo',
      'max',
      'twitch',
      'steam',
      'epic games',
      'gamepass',
      'playstation',
      'xbox',
      'nintendo',
      'deezer'
    ])) {
      return Category.entertainment;
    }

    /// TRANSPORT / RIDES / FUEL
    if (_containsAny(text, [
      'uber',
      'uber trip',
      'uber eats',
      '99',
      'taxi',
      'cabify',
      'posto',
      'gasolina',
      'combustivel',
      'fuel',
      'shell',
      'ipiranga',
      'petrobras',
      'br',
      'texaco',
      'esso'
    ])) {
      return Category.transport;
    }

    /// HEALTH / PHARMACY
    if (_containsAny(text, [
      'farmacia',
      'pharmacy',
      'drogaria',
      'droga',
      'raia',
      'drogasil',
      'pague menos',
      'panvel',
      'ultrafarma'
    ])) {
      return Category.health;
    }

    /// UTILITIES
    if (_containsAny(text, [
      'energia',
      'electric',
      'luz',
      'water',
      'agua',
      'saneamento',
      'gas',
      'internet',
      'wifi',
      'vivo',
      'claro',
      'tim',
      'oi'
    ])) {
      return Category.utilities;
    }

    /// EDUCATION
    if (_containsAny(text, [
      'udemy',
      'coursera',
      'alura',
      'ebac',
      'school',
      'faculdade',
      'universidade'
    ])) {
      return Category.education;
    }

    return Category.others;
  }

  static bool _containsAny(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }
    return false;
  }
}