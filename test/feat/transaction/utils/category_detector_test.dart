import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/utils/expense_category_detector.dart';
import 'package:finances_control/feat/transaction/utils/income_category_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseCategoryDetector', () {
    test('categorizes noisy real-world expenses with priority rules', () {
      expect(ExpenseCategoryDetector.detect('Uber Uber *Trip Help.U'), Category.transport);
      expect(ExpenseCategoryDetector.detect('Ifd*I. A. Marques e Co'), Category.food);
      expect(ExpenseCategoryDetector.detect('Dm *Twitch'), Category.subscription);
      expect(ExpenseCategoryDetector.detect('Google Tinder Dating'), Category.subscription);
      expect(ExpenseCategoryDetector.detect('Panificadora e Confeit'), Category.food);
      expect(ExpenseCategoryDetector.detect('Supermercado Preco B'), Category.food);
      expect(ExpenseCategoryDetector.detect('Lojas Americanas'), Category.shopping);
      expect(ExpenseCategoryDetector.detect('TIM S A'), Category.internet);
      expect(ExpenseCategoryDetector.detect('Apetit Servicos de Ali'), Category.food);
      expect(ExpenseCategoryDetector.detect('Quinto Andar'), Category.rent);
    });

    test('keeps specific precedence over generic matches', () {
      expect(ExpenseCategoryDetector.detect('Uber Eats Pedido'), Category.food);
      expect(ExpenseCategoryDetector.detect('Google YouTube Premium'), Category.subscription);
    });
  });

  group('IncomeCategoryDetector', () {
    test('categorizes noisy real-world income descriptions', () {
      expect(IncomeCategoryDetector.detect('Transferência Recebida'), Category.transferReceived);
      expect(IncomeCategoryDetector.detect('Pix Recebido Fulano'), Category.pixReceived);
      expect(IncomeCategoryDetector.detect('PLR Empresa'), Category.bonus);
      expect(IncomeCategoryDetector.detect('Hotmart Club'), Category.digitalProducts);
      expect(IncomeCategoryDetector.detect('Paypal Transfer'), Category.digitalProducts);
      expect(IncomeCategoryDetector.detect('Dividendos carteira'), Category.dividends);
      expect(IncomeCategoryDetector.detect('Rendimento mensal investimento'), Category.investment);
      expect(IncomeCategoryDetector.detect('Servico Prestado Cliente XYZ'), Category.freelance);
    });
  });
}
