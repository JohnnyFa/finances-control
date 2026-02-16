import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/category_by_type.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/ui/widgets/transaction_feedback.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

import '../../onboarding/ui/widgets/app_text_field.dart';
import 'transaction_label_resolver.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime? endDate;
  TransactionType type = TransactionType.expense;
  Category category = Category.food;

  List<Category> get categories => categoryByType[type] ?? [];

  bool isRecurring = false;
  int recurringDay = 1;
  bool _isTyping = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    amountController.addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    amountController.removeListener(_onAmountChanged);
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _onAmountChanged() {
    if (!_isTyping) {
      setState(() => _isTyping = true);

      Future.delayed(const Duration(milliseconds: 120), () {
        if (mounted) {
          setState(() => _isTyping = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<TransactionViewModel, TransactionState>(
      listener: (context, state) async {
        if (state.status == TransactionStatus.success) {
          await _showTransactionFeedback(context, type);
          _hasChanges = true;
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _hasChanges);
            },
          ),
          title: CustomText(
            description: "-",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          actions: [
            BlocBuilder<TransactionViewModel, TransactionState>(
              buildWhen: (prev, curr) => prev.status != curr.status,
              builder: (context, state) {
                final theme = Theme.of(context);
                final loading = state.status == TransactionStatus.loading;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SizedBox(
                    height: 36,
                    child: TextButton(
                      onPressed: loading ? null : _save,
                      style: TextButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: theme.colorScheme.surface,
                            width: 1,
                          ),
                        ),
                      ),
                      child: loading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.surface,
                              ),
                            )
                          : Text(
                              context.appStrings.save,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildAmount(),
            SizedBox(height: 14),
            _buildTypeSelector(),
            SizedBox(height: 14),
            _buildCategory(),
            SizedBox(height: 14),
            _buildStartDate(),
            SizedBox(height: 14),
            _buildRecurringToggle(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: isRecurring ? _recurringSection(theme) : const SizedBox(),
            ),
            SizedBox(height: 14),
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _recurringSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14),
        _buildRecurringDay(theme),
        SizedBox(height: 14),
        _buildEndDate(theme),
      ],
    );
  }

  Widget _buildAmount() {
    final scheme = Theme.of(context).colorScheme;

    final Color amountColor = type == TransactionType.income
        ? const Color(0xFF5CCB7A)
        : const Color(0xFFE57373);

    final amountTextStyle = TextStyle(
      fontSize: 52,
      fontWeight: FontWeight.w800,
      color: amountColor,
    );

    return Center(
      child: AnimatedScale(
        scale: _isTyping ? 1.05 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            CurrencyInputFormatter(
              useSymbolPadding: true,
              thousandSeparator: ThousandSeparator.Period,
              mantissaLength: 2,
            ),
          ],
          style: amountTextStyle,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "R\$0,00",
            hintStyle: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        _typeButton(
          TransactionType.income,
          selectedColor: const Color(0xFF5CCB7A),
        ),
        const SizedBox(width: 16),
        _typeButton(
          TransactionType.expense,
          selectedColor: const Color(0xFFE57373),
        ),
      ],
    );
  }

  Widget _typeButton(TransactionType value, {required Color selectedColor}) {
    final selected = type == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            type = value;
            category = categories.first;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: selected
                ? selectedColor
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? selectedColor
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.08),
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: selectedColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              transactionTypeLabel(context, value),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("📂 ${context.appStrings.category}"),
        const SizedBox(height: 12),
        AppTextField(
          hintText:
              "${categoryEmoji(context, category)} ${categoryLabel(context, category)}",
          readOnly: true,
          onTap: _openCategorySelector,
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    final scheme = Theme.of(context).colorScheme;

    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
        color: scheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildStartDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("📅 ${context.appStrings.date}"),
        const SizedBox(height: 12),
        AppTextField(
          controller: TextEditingController(
            text: DateFormat("dd MMM yyyy").format(selectedDate),
          ),
          readOnly: true,
          onTap: _pickStartDate,
        ),
      ],
    );
  }

  Widget _buildRecurringToggle() {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("📅 ${context.appStrings.recurring_transaction}"),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(
                context.appStrings.repeat_monthly,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
              const Spacer(),
              Switch(
                value: isRecurring,
                onChanged: (value) {
                  setState(() {
                    isRecurring = value;
                    recurringDay = selectedDate.day;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("📝 ${context.appStrings.description}"),
        const SizedBox(height: 12),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AppTextField(
            controller: descriptionController,
            hintText: context.appStrings.add_description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            minLines: 1,
          ),
        ),
      ],
    );
  }

  void _save() {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.appStrings.fill_the_field)),
      );
      return;
    }

    final int amount = int.parse(toNumericString(amountController.text));

    if (isRecurring) {
      final recurring = RecurringTransaction(
        amount: amount.toInt(),
        type: type,
        category: category,
        dayOfMonth: recurringDay,
        startDate: selectedDate,
        endDate: endDate,
        description: descriptionController.text,
        active: true,
      );

      context.read<TransactionViewModel>().addRecurring(recurring);
    } else {
      final tx = Transaction(
        amount: amount.toInt(),
        type: type,
        category: category,
        date: selectedDate,
        description: descriptionController.text,
      );

      context.read<TransactionViewModel>().add(tx);
    }
  }

  Future<void> _showTransactionFeedback(
    BuildContext context,
    TransactionType type,
  ) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "feedback",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return HighImpactFeedback(type: type);
      },
    );
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

  Widget _buildRecurringDay(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.event_repeat,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomText(
            description: context.appStrings.every,
            fontWeight: FontWeight.w600,
          ),
        ),
        DropdownButton<int>(
          value: recurringDay,
          items: List.generate(
            28,
            (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
          ),
          onChanged: (value) {
            if (value != null) {
              setState(() => recurringDay = value);
            }
          },
        ),
      ],
    );
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        recurringDay = picked.day;
      });
    }
  }

  Widget _buildEndDate(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.flag,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomText(
            description:
                "${context.appStrings.end} (${context.appStrings.optional})",
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: _pickEndDate,
          child: CustomText(
            description: endDate == null
                ? context.appStrings.no_data
                : DateFormat("dd MMM yyyy").format(endDate!),
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? selectedDate,
      firstDate: selectedDate,
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  Future<void> _openCategorySelector() async {
    final selected = await showModalBottomSheet<Category>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        final scheme = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                ...categories.map(
                  (c) => ListTile(
                    leading: Text(
                      categoryEmoji(context, c),
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(categoryLabel(context, c)),
                    onTap: () => Navigator.pop(context, c),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => category = selected);
    }
  }
}
