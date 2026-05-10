import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/utils/transaction_text_normalizer.dart';

class ExpenseCategoryDetector {
  static Category detect(String description) {
    final text = TransactionTextNormalizer.normalize(description);

    // Priority 1: explicit subscription vendors and specific platform combinations.
    if (_containsAny(text, [
      'google tinder',
      'google youtube',
      'google one',
      'google play',
      'youtube premium',
      'apple services',
      'apple com bill',
      'dm twitch',
      'discord nitro',
      'xbox game pass',
      'chatgpt',
      'openai',
      'notion',
      'canva',
      'icloud',
      'netflix',
      'spotify',
      'disney plus',
      'hbo max',
      'twitch',
      'steam',
      'deezer',
      'playstation',
      'xbox',
      'amazon prime',
    ])) {
      return Category.subscription;
    }

    // Priority 2: food-specific transport variants should win over transport.
    if (_containsAny(text, [
      'uber eats',
      'uber flash food',
      'ifood',
      'ifd',
      'rappi',
      'aiqfome',
      'ze delivery',
      'apetit',
      'produtos alimenticios',
      'restaurante',
      'restaurant',
      'panificadora',
      'confeit',
      'padaria',
      'cafeteria',
      'burger',
      'hamburguer',
      'sushi',
      'lanche',
      'bar',
    ])) {
      return Category.food;
    }

    // Grocery still maps to food by design.
    if (_containsAny(text, [
      'supermercado',
      'mercado',
      'atacado',
      'atacadao',
      'assai',
      'condor',
      'conveniencia',
      'hortifruti',
      'carrefour',
      'extra',
      'pao de acucar',
    ])) {
      return Category.food;
    }

    if (_containsAny(text, [
      'uber trip',
      'uber',
      '99',
      'cabify',
      'taxi',
      'posto',
      'combustivel',
      'shell',
      'ipiranga',
      'petrobras',
      'estacionamento',
      'pedagio',
    ])) {
      return Category.transport;
    }

    if (_containsAny(text, [
      'quinto andar',
      'aluguel',
      'imobiliaria',
      'rent',
      'locacao',
    ])) {
      return Category.rent;
    }

    if (_containsAny(text, [
      'amazon',
      'mercado livre',
      'mercadolivre',
      'shopee',
      'aliexpress',
      'shein',
      'americanas',
      'magalu',
      'casas bahia',
      'kabum',
      'netshoes',
    ])) {
      return Category.shopping;
    }

    if (_containsAny(text, [
      'farmacia',
      'drogaria',
      'exames',
      'hospital',
      'odontologia',
      'laboratorio',
    ])) {
      return Category.health;
    }

    if (_containsAny(text, [
      'tim s a',
      'tim',
      'vivo',
      'claro',
      'oi',
      'fibra',
      'internet',
      'telecom',
    ])) {
      return Category.internet;
    }

    if (_containsAny(text, [
      'cpfl',
      'enel',
      'light',
      'cemig',
      'energia',
    ])) {
      return Category.electricity;
    }

    if (_containsAny(text, ['sabesp', 'sanepar', 'agua', 'copasa'])) {
      return Category.water;
    }

    if (_containsAny(text, ['gas', 'condominio', 'residencial'])) {
      return Category.utilities;
    }

    if (_containsAny(text, [
      'alura',
      'udemy',
      'coursera',
      'faculdade',
      'universidade',
      'curso',
    ])) {
      return Category.education;
    }

    if (_containsAny(text, [
      'cinemark',
      'ingresso com',
      'eventim',
      'show ingresso',
      'playcenter',
      'boliche',
    ])) {
      return Category.entertainment;
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
