import 'package:finances_control/feat/transaction/domain/category.dart';

class IncomeCategoryDetector {
  static Category detect(String description) {
    final text = _normalize(description);

    if (_containsAny(text, ['salario', 'salary', 'folha', 'payroll', 'proventos'])) {
      return Category.salary;
    }

    if (_containsAny(text, ['pix recebido', 'pix rec'])) {
      return Category.pixReceived;
    }

    if (_containsAny(text, ['ted recebida', 'transferencia recebida'])) {
      return Category.transferReceived;
    }

    if (_containsAny(text, ['dividend', 'dividendo', 'rendimento', 'juros', 'investimento'])) {
      return Category.investment;
    }

    if (_containsAny(text, ['hotmart', 'monetizze', 'kiwify', 'braip', 'eduzz', 'paypal', 'stripe', 'google ads', 'adsense'])) {
      return Category.digitalProducts;
    }

    if (_containsAny(text, ['cashback'])) return Category.cashback;

    if (_containsAny(text, ['estorno', 'reembolso', 'refund'])) return Category.refund;

    if (_containsAny(text, ['venda online', 'venda', 'servico', 'freelancer', 'freelance'])) {
      return Category.sales;
    }

    return Category.others;
  }

  static String _normalize(String text) {
    final lower = text.toLowerCase();

    const accentMap = <String, String>{
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
      'ñ': 'n',
    };

    final normalized = StringBuffer();
    for (final char in lower.runes) {
      final character = String.fromCharCode(char);
      normalized.write(accentMap[character] ?? character);
    }

    return normalized.toString();
  }

  static bool _containsAny(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}
