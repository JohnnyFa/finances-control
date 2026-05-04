import 'package:finances_control/feat/transaction/domain/category.dart';

class CategoryDetector {
  static Category detect(String description) {
    final text = description.toLowerCase();

    /// SUBSCRIPTIONS / DIGITAL
    if (_containsAny(text, [
      'netflix',
      'spotify',
      'youtube premium',
      'youtube',
      'disney+',
      'disneyplus',
      'hbo max',
      'max ',
      'twitch',
      'steam',
      'epic games',
      'game pass',
      'gamepass',
      'playstation',
      'xbox',
      'nintendo',
      'deezer',
      'amazon prime',
      'google play',
      'apple.com',
      'apple services',
      'icloud',
      'canva',
      'notion',
      'chatgpt',
      'openai',
      'hotmart',
      'monetizze',
      'kiwify',
      'braip',
      'eduzz',
    ])) {
      return Category.subscription;
    }

    /// TRANSPORT
    if (_containsAny(text, [
      'uber',
      'uber trip',
      'uber br',
      '99app',
      '99pop',
      '99 taxi',
      'cabify',
      'taxi',
      'shell',
      'ipiranga',
      'petrobras',
      'vibra energia',
      'ale combustiveis',
      'texaco',
      'esso',
    ])) {
      return Category.transport;
    }

    /// FOOD (restaurants / delivery)
    if (_containsAny(text, [
      'ifood',
      'ifd',
      'rappi',
      'aiqfome',
      'ze delivery',
      'mcdonald',
      'burger king',
      'subway',
      'kfc',
      'habibs',
      'outback',
      'starbucks',
      'pizzaria',
      'pizza hut',
      'dominos',
      'lanche',
      'hamburguer',
      'cafeteria',
      'padaria',
      'panificadora',
    ])) {
      return Category.food;
    }

    /// SUPERMARKETS / GROCERIES
    if (_containsAny(text, [
      'carrefour',
      'carrefour bairro',
      'extra',
      'assai',
      'atacadao',
      'dia supermercado',
      'condor',
      'pao de acucar',
      'zaffari',
      'sonda supermercado',
      'super nosso',
      'walmart',
    ])) {
      return Category.food;
    }

    /// SHOPPING / RETAIL
    if (_containsAny(text, [
      'amazonmktplc',
      'amazon br',
      'mercado livre',
      'mercadolivre',
      'shopee',
      'magalu',
      'magazineluiza',
      'americanas',
      'submarino',
      'aliexpress',
      'shein',
      'centauro',
      'nike',
      'adidas',
      'renner',
      'riachuelo',
      'c&a',
      'h&m',
      'kabum',
      'netshoes',
      'casas bahia',
      'ponto frio',
      'fast shop',
      'dafiti',
    ])) {
      return Category.shopping;
    }

    /// HEALTH / PHARMACY / HEALTH INSURANCE
    if (_containsAny(text, [
      'farmacia',
      'drogaria',
      'drogasil',
      'droga raia',
      'pague menos',
      'panvel',
      'ultrafarma',
      'unimed',
      'amil',
      'hapvida',
      'notredame',
      'bradesco saude',
      'sulamerica saude',
    ])) {
      return Category.health;
    }

    /// INTERNET (providers only)
    if (_containsAny(text, [
      'vivo fibra',
      'claro net',
      'claro flex',
      'tim live',
      'oi fibra',
      'brisanet',
      'desktop internet',
      'algar telecom',
    ])) {
      return Category.internet;
    }

    /// ELECTRICITY
    if (_containsAny(text, [
      'cpfl',
      'enel',
      'light',
      'edp',
      'copel',
      'cemig',
      'neoenergia',
      'equatorial energia',
      'elektro',
    ])) {
      return Category.electricity;
    }

    /// WATER (companies only)
    if (_containsAny(text, [
      'sabesp',
      'copasa',
      'sanepar',
      'cedae',
      'caesb',
      'embasa',
      'corsan',
      'compesa',
    ])) {
      return Category.water;
    }

    /// UTILITIES
    if (_containsAny(text, [
      'gas natural',
      'ultragaz',
      'supergasbras',
      'comgas',
      'consigaz',
      'condominio',
    ])) {
      return Category.utilities;
    }

    /// EDUCATION
    if (_containsAny(text, [
      'udemy',
      'coursera',
      'alura',
      'ebac',
      'rocketseat',
      'dio',
      'descomplica',
      'estacio',
      'anhanguera',
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
