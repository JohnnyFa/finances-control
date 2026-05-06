import 'package:finances_control/feat/transaction/domain/category.dart';

class IncomeCategoryDetector {
  static Category detect(String description) {
    final text = description.toLowerCase();

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

  static bool _containsAny(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) return true;
    }
    return false;
  }
}
