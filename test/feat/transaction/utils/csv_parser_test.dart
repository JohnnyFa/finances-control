import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/services/csv_header_detector.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CsvParser', () {
    final parser = CsvParser();

    test('imports only expenses for credit account and ignores payments', () {
      const csv = '''
Data,Descrição,Valor,Categoria,Cartão
10/03/2026,Supermercado,-150.00,Alimentação,Gold
11/03/2026,Pagamento recebido,150.00,Fatura,Gold
12/03/2026,Fatura cartão,900.00,Fatura,Gold
''';

      final result = parser.parse(csv);

      expect(result, hasLength(1));
      expect(result.first.type, TransactionType.expense);
      expect(result.first.amount, 15000);
      expect(result.first.description, 'Supermercado');
    });

    test('imports income and expense for checking account using amount sign', () {
      const csv = '''
Data,Descrição,Valor,Identificador,Tipo
10/03/2026,Salário,2500.00,1,Crédito
11/03/2026,Supermercado,-420.55,2,Débito
''';

      final result = parser.parse(csv);

      expect(result, hasLength(2));
      expect(result[0].type, TransactionType.income);
      expect(result[0].amount, 250000);
      expect(result[1].type, TransactionType.expense);
      expect(result[1].amount, 42055);
    });

    test('preserves decimal separator for mixed comma and dot amounts', () {
      const csv = '''
Data,Descrição,Valor,Identificador,Tipo
10/03/2026,Freelance,"1,234.56",1,Crédito
11/03/2026,Investimento,"1.234,56",2,Crédito
''';

      final result = parser.parse(csv);

      expect(result, hasLength(2));
      expect(result[0].type, TransactionType.income);
      expect(result[0].amount, 123456);
      expect(result[1].type, TransactionType.income);
      expect(result[1].amount, 123456);
    });

    test('ignores transfer rows for checking account', () {
      const csv = '''
Data,Descrição,Valor,Identificador,Tipo
10/03/2026,Transferência recebida,100.00,1,Crédito
11/03/2026,Transfer pix,-20.00,2,Débito
12/03/2026,Padaria,-10.00,3,Débito
''';

      final result = parser.parse(csv);

      expect(result, hasLength(1));
      expect(result.first.description, 'Padaria');
      expect(result.first.type, TransactionType.expense);
    });

    test('detectAccountType identifies credit and checking headers', () {
      expect(
        CsvHeaderDetector.detectAccountType([
          'Data',
          'Descrição',
          'Valor',
          'Categoria',
          'Cartão',
        ]),
        AccountType.credit,
      );

      expect(
        CsvHeaderDetector.detectAccountType([
          'Data',
          'Descrição',
          'Valor',
          'Identificador',
          'Tipo',
        ]),
        AccountType.checking,
      );
    });
  });
}
