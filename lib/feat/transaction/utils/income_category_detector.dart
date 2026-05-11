import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/utils/transaction_text_normalizer.dart';

class IncomeCategoryDetector {
  static Category detect(String description) {
    final text = TransactionTextNormalizer.normalize(description);

    if (_containsAny(text, ['bonus', 'plr', 'participacao nos lucros', 'premio', 'incentivo'])) {
      return Category.bonus;
    }

    if (_containsAny(text, ['salario', 'salary', 'folha', 'payroll', 'proventos', 'pagamento empresa'])) {
      return Category.salary;
    }

    if (_containsAny(text, ['pix recebido', 'pix rec', 'pix creditado'])) {
      return Category.pixReceived;
    }

    if (_containsAny(text, ['transferencia recebida', 'ted recebida', 'deposito recebido'])) {
      return Category.transferReceived;
    }

    if (_containsAny(text, ['dividend', 'dividendo'])) {
      return Category.dividends;
    }

    if (_containsAny(text, ['rendimento', 'juros', 'investimento'])) {
      return Category.investment;
    }

    if (_containsAny(text, ['hotmart', 'monetizze', 'kiwify', 'braip', 'eduzz', 'stripe', 'paypal', 'adsense', 'google ads'])) {
      return Category.digitalProducts;
    }

    if (_containsAny(text, ['freelance', 'freelancer', 'servico prestado'])) {
      return Category.freelance;
    }

    if (_containsAny(text, ['venda online', 'venda', 'ecommerce'])) {
      return Category.sales;
    }

    if (_containsAny(text, ['estorno', 'refund', 'chargeback', 'reembolso'])) {
      return Category.refund;
    }

    if (_containsAny(text, ['cashback', 'reward', 'pontos'])) {
      return Category.cashback;
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
