import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/category_by_type.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/ui/transaction_label_resolver.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:finances_control/widget/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

class TransactionDetailsPage extends StatefulWidget {
  final Transaction transaction;

  const TransactionDetailsPage({super.key, required this.transaction});

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;

  late DateTime _selectedDate;
  late TransactionType _type;
  late Category _category;

  List<Category> get _categories => categoryByType[_type] ?? [];

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.transaction.date;
    _type = widget.transaction.type;
    _category = widget.transaction.category;
    _amountController = TextEditingController(
      text: formatCurrencyFromCents(context, widget.transaction.amount),
    );
    _descriptionController = TextEditingController(
      text: widget.transaction.description,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocListener<TransactionViewModel, TransactionState>(
      listener: (context, state) {
        if (state.status == TransactionStatus.success) {
          Navigator.of(context).pop(true);
        }

        if (state.status == TransactionStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? context.appStrings.unexpected_error,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.appStrings.transaction_details),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              '${_type == TransactionType.income ? '+' : '-'}${_amountController.text}',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: _type == TransactionType.income
                    ? const Color(0xFF14AE5C)
                    : scheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildTypeSelector(),
            const SizedBox(height: 12),
            _buildCategory(),
            const SizedBox(height: 12),
            _buildDate(),
            const SizedBox(height: 12),
            AppTextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                CurrencyInputFormatter(
                  useSymbolPadding: true,
                  thousandSeparator: ThousandSeparator.Period,
                  mantissaLength: 2,
                ),
              ],
              hintText: context.appStrings.value,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _descriptionController,
              hintText: context.appStrings.description,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: Text(context.appStrings.update_transaction),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _confirmDelete,
              icon: Icon(Icons.delete_outline, color: scheme.error),
              label: Text(
                context.appStrings.delete_transaction,
                style: TextStyle(color: scheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        Expanded(child: _typeButton(TransactionType.income)),
        const SizedBox(width: 8),
        Expanded(child: _typeButton(TransactionType.expense)),
      ],
    );
  }

  Widget _typeButton(TransactionType value) {
    final selected = _type == value;
    final scheme = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(transactionTypeLabel(context, value)),
      selected: selected,
      onSelected: (_) {
        setState(() {
          _type = value;
          _category = _categories.first;
        });
      },
      selectedColor: scheme.primary,
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimary : scheme.onSurface,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _buildCategory() {
    return AppTextField(
      readOnly: true,
      hintText: '${categoryEmoji(context, _category)} ${categoryLabel(context, _category)}',
      onTap: () async {
        final result = await showModalBottomSheet<Category>(
          context: context,
          builder: (context) {
            return SafeArea(
              child: ListView(
                shrinkWrap: true,
                children: _categories
                    .map(
                      (category) => ListTile(
                        leading: Text(categoryEmoji(context, category)),
                        title: Text(categoryLabel(context, category)),
                        onTap: () => Navigator.pop(context, category),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );

        if (result != null) {
          setState(() => _category = result);
        }
      },
      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
    );
  }

  Widget _buildDate() {
    return AppTextField(
      readOnly: true,
      hintText: DateFormat('dd MMM yyyy').format(_selectedDate),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );

        if (picked != null) {
          setState(() => _selectedDate = picked);
        }
      },
      suffixIcon: const Icon(Icons.calendar_month_outlined),
    );
  }

  void _save() {
    if (widget.transaction.id == null || _amountController.text.isEmpty) return;

    final amount = int.parse(toNumericString(_amountController.text));

    context.read<TransactionViewModel>().update(
      Transaction(
        id: widget.transaction.id,
        amount: amount,
        type: _type,
        category: _category,
        date: _selectedDate,
        description: _descriptionController.text,
      ),
    );
  }

  Future<void> _confirmDelete() async {
    if (widget.transaction.id == null) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.appStrings.delete_transaction),
        content: Text(context.appStrings.delete_transaction_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.appStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.appStrings.delete),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      context.read<TransactionViewModel>().delete(widget.transaction.id!);
    }
  }
}
