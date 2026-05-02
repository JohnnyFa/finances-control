import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_recurring_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/update_transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/detail_transaction_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUpdateTransactionUseCase extends Mock implements UpdateTransactionUseCase {}
class MockDeleteTransactionUseCase extends Mock implements DeleteTransactionUseCase {}
class MockDeleteRecurringTransactionUseCase extends Mock implements DeleteRecurringTransactionUseCase {}

class FakeTransaction extends Fake implements Transaction {}

void main() {
  late DetailTransactionViewModel viewModel;
  late MockUpdateTransactionUseCase mockUpdateUseCase;
  late MockDeleteTransactionUseCase mockDeleteUseCase;
  late MockDeleteRecurringTransactionUseCase mockDeleteRecurringUseCase;
  late Transaction initialTransaction;

  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });

  setUp(() {
    mockUpdateUseCase = MockUpdateTransactionUseCase();
    mockDeleteUseCase = MockDeleteTransactionUseCase();
    mockDeleteRecurringUseCase = MockDeleteRecurringTransactionUseCase();

    initialTransaction = Transaction(
      id: 1,
      amount: 1000,
      type: TransactionType.expense,
      category: Category.food,
      date: DateTime(2023, 1, 1),
      description: 'Initial description',
    );

    viewModel = DetailTransactionViewModel(
      transaction: initialTransaction,
      updateUseCase: mockUpdateUseCase,
      deleteUseCase: mockDeleteUseCase,
      deleteRecurringUseCase: mockDeleteRecurringUseCase,
    );
  });

  test('initial state has correct transaction', () {
    expect(viewModel.state.transaction, initialTransaction);
    expect(viewModel.state.isLoading, false);
    expect(viewModel.state.errorMessage, isNull);
    expect(viewModel.state.isDeleted, false);
    expect(viewModel.state.hasUpdated, false);
  });

  group('updateCategory', () {
    test('calls updateUseCase and emits updated state with hasUpdated true', () async {
      when(() => mockUpdateUseCase(any())).thenAnswer((_) async => {});

      await viewModel.updateCategory(Category.transport);

      verify(() => mockUpdateUseCase(any())).called(1);
      expect(viewModel.state.transaction.category, Category.transport);
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.hasUpdated, true);
    });

    test('emits error message on failure', () async {
      when(() => mockUpdateUseCase(any())).thenThrow(Exception('Update failed'));

      await viewModel.updateCategory(Category.transport);

      expect(viewModel.state.errorMessage, contains('Update failed'));
      expect(viewModel.state.isLoading, false);
    });
  });

  group('updateDescription', () {
    test('calls updateUseCase and emits updated state with hasUpdated true', () async {
      when(() => mockUpdateUseCase(any())).thenAnswer((_) async => {});

      await viewModel.updateDescription('New description');

      verify(() => mockUpdateUseCase(any())).called(1);
      expect(viewModel.state.transaction.description, 'New description');
      expect(viewModel.state.hasUpdated, true);
    });
  });

  group('updateAmount', () {
    test('calls updateUseCase and emits updated state with hasUpdated true', () async {
      when(() => mockUpdateUseCase(any())).thenAnswer((_) async => {});

      await viewModel.updateAmount(2000);

      verify(() => mockUpdateUseCase(any())).called(1);
      expect(viewModel.state.transaction.amount, 2000);
      expect(viewModel.state.hasUpdated, true);
    });
  });

  group('delete', () {
    test('calls deleteUseCase for non-generated transaction', () async {
      when(() => mockDeleteUseCase(any())).thenAnswer((_) async => {});

      await viewModel.delete();

      verify(() => mockDeleteUseCase(1)).called(1);
      expect(viewModel.state.isDeleted, true);
    });

    test('calls deleteRecurringUseCase for generated transaction', () async {
      final generatedTx = Transaction(
        id: 2,
        amount: 500,
        type: TransactionType.expense,
        category: Category.rent,
        date: DateTime(2023, 1, 1),
        description: 'Generated',
        isGenerated: true,
      );
      viewModel = DetailTransactionViewModel(
        transaction: generatedTx,
        updateUseCase: mockUpdateUseCase,
        deleteUseCase: mockDeleteUseCase,
        deleteRecurringUseCase: mockDeleteRecurringUseCase,
      );
      when(() => mockDeleteRecurringUseCase(any())).thenAnswer((_) async => {});

      await viewModel.delete();

      verify(() => mockDeleteRecurringUseCase(2)).called(1);
      expect(viewModel.state.isDeleted, true);
    });

    test('emits error message on failure', () async {
      when(() => mockDeleteUseCase(any())).thenThrow(Exception('Delete failed'));

      await viewModel.delete();

      expect(viewModel.state.errorMessage, contains('Delete failed'));
      expect(viewModel.state.isDeleted, false);
    });
  });
}
