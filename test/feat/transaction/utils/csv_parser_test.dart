import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser_debit.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CsvParser (Existing Credit Parser)', () {
    final parser = CsvParser();

    test('should parse credit card CSV ignoring negative values', () {
      const csv = '''Data,Descricao,Valor
2026-05-01,Amazon,150.00
2026-05-02,Estorno,-50.00
2026-05-03,iFood,35.50''';

      final transactions = parser.parse(csv);

      expect(transactions.length, 2);
      expect(transactions[0].description, 'Amazon');
      expect(transactions[0].amount, 15000);
      expect(transactions[0].type, TransactionType.expense);
      
      expect(transactions[1].description, 'iFood');
      expect(transactions[1].amount, 3550);
      expect(transactions[1].type, TransactionType.expense);
    });

    test('should parse BR date format', () {
      const csv = '''Data,Descricao,Valor
15/05/2026,Market,10.00''';

      final transactions = parser.parse(csv);

      expect(transactions.first.date, DateTime(2026, 5, 15));
    });
  });

  group('CsvParserDebit', () {
    final parser = CsvParserDebit();

    test('should parse debit CSV including income and expenses', () {
      const csv = '''Data,Historico,Valor,Saldo
01/05/2026,Salary,2000.00,2000.00
02/05/2026,Rent,-1000.00,1000.00
03/05/2026,Dividend,50.25,1050.25''';

      final transactions = parser.parse(csv);

      expect(transactions.length, 3);
      
      expect(transactions[0].description, 'Salary');
      expect(transactions[0].amount, 200000);
      expect(transactions[0].type, TransactionType.income);
      expect(transactions[0].category, Category.salary);

      expect(transactions[1].description, 'Rent');
      expect(transactions[1].amount, 100000);
      expect(transactions[1].type, TransactionType.expense);
      expect(transactions[1].category, Category.rent);

      expect(transactions[2].description, 'Dividend');
      expect(transactions[2].amount, 5025);
      expect(transactions[2].type, TransactionType.income);
      expect(transactions[2].category, Category.dividends);
    });

    test('should handle comma as decimal separator', () {
      const csv = '''Data,Historico,Valor
01/05/2026,Market,"-15,50"''';

      final transactions = parser.parse(csv);

      expect(transactions.first.amount, 1550);
      expect(transactions.first.type, TransactionType.expense);
    });

    test('should categorize digital income and not as expense subscription', () {
      const csv = '''Data,Historico,Valor
01/05/2026,HOTMART,120.00
02/05/2026,KIWIFY,90.00''';

      final transactions = parser.parse(csv);

      expect(transactions[0].category, Category.digitalProducts);
      expect(transactions[1].category, Category.digitalProducts);
      expect(transactions.every((t) => t.type == TransactionType.income), true);
    });
  });

  group('CsvParserResolver', () {
    test('should detect debit CSV by headers', () {
      const csv = 'Data,Historico,Valor,Saldo\n01/05/2026,Test,10.00,10.00';
      expect(CsvParserResolver.parse(csv).first.type, TransactionType.income);
    });

    test('should detect debit CSV by both positive and negative values', () {
      const csv = 'Date,Description,Amount,Tipo\n2026-05-01,In,100.00,D\n2026-05-02,Out,-50.00,D';
      final transactions = CsvParserResolver.parse(csv);
      expect(transactions.length, 2);
      expect(transactions[0].type, TransactionType.income);
      expect(transactions[1].type, TransactionType.expense);
    });

    test('should fallback to credit parser for standard credit CSV', () {
      const csv = 'Date,Description,Amount\n2026-05-01,Store,100.00';
      final transactions = CsvParserResolver.parse(csv);
      expect(transactions.length, 1);
      expect(transactions[0].type, TransactionType.expense);
    });
  });
}
