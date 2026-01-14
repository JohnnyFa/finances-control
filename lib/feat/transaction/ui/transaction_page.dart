import 'package:big_decimal/big_decimal.dart';
import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/category_by_type.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

import 'transaction_label_resolver.dart';
import 'wigets/transaction_feedback.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TransactionType type = TransactionType.expense;
  Category category = Category.food;

  List<Category> get categories => categoryByType[type] ?? [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<TransactionViewModel, TransactionState>(
      listener: (context, state) async {
        if (state.status == TransactionStatus.success) {
          await _showFeedback();
        }

        if (state.status == TransactionStatus.error) {
          await _onError(state);
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: CustomText(
            description: "-",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: BlocBuilder<TransactionViewModel, TransactionState>(
                buildWhen: (prev, curr) => prev.status != curr.status,
                builder: (context, state) {
                  final loading = state.status == TransactionStatus.loading;

                  return ElevatedButton(
                    onPressed: loading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : CustomText(
                            description: context.appStrings.save,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimary,
                          ),
                  );
                },
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildAmount(theme),
            _divider(theme),
            _buildTypeSelector(theme),
            _divider(theme),
            _buildCategory(theme),
            _divider(theme),
            _buildDate(theme),
            _divider(theme),
            _buildDescription(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAmount(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.attach_money,
          color: theme.colorScheme.onSurface..withValues(alpha: 0.6),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CurrencyInputFormatter(
                useSymbolPadding: true,
                thousandSeparator: ThousandSeparator.Comma,
                mantissaLength: 2,
              ),
            ],
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: "\$ 0.00",
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector(ThemeData theme) {
    return Row(
      children: [
        _typeButton(TransactionType.income, const Color(0xFF6BD49F)),
        const SizedBox(width: 12),
        _typeButton(TransactionType.expense, const Color(0xFFFF6B6B)),
      ],
    );
  }

  Widget _typeButton(TransactionType value, Color color) {
    final bool selected = type == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            type = value;
            category = categories.first;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? color : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomText(
              description: transactionTypeLabel(context, value),
              fontWeight: FontWeight.w600,
              color: selected ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.category,
          color: theme.colorScheme.onSurface..withValues(alpha: 0.6),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButton<Category>(
            value: category,
            isExpanded: true,
            dropdownColor: theme.cardColor,
            underline: const SizedBox(),
            items: categories
                .map(
                  (c) => DropdownMenuItem<Category>(
                    value: c,
                    child: CustomText(
                      description: categoryLabel(context, c),
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => category = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDate(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          color: theme.colorScheme.onSurface..withValues(alpha: 0.6),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: _pickDate,
          child: CustomText(
            description: DateFormat("dd MMM yyyy").format(selectedDate),
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.notes,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: descriptionController,
            style: TextStyle(color: theme.colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: context.appStrings.description,
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface..withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(
        color: theme.colorScheme.onSurface..withValues(alpha: 0.08),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _save() {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.appStrings.fill_the_field)),
      );
      return;
    }

    final BigDecimal amount = BigDecimal.parse(
      toNumericString(amountController.text),
    );

    final Transaction tx = Transaction(
      amount: amount,
      type: type,
      category: category,
      date: selectedDate,
      description: descriptionController.text,
    );

    context.read<TransactionViewModel>().add(tx);
  }

  Future<void> _showFeedback() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => TransactionFeedbackPage(type: type),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _onError(TransactionState state) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.errorMessage ?? context.appStrings.unexpected_error,
        ),
      ),
    );
  }
}
