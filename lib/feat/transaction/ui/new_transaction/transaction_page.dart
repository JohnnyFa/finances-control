import 'dart:async';

import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/ads/enum/ad_placement.dart';
import 'package:finances_control/feat/ads/ui/banner_add_widget.dart';
import 'package:finances_control/feat/ads/vm/ad_state.dart';
import 'package:finances_control/feat/ads/vm/ad_viewmodel.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/category_by_type.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/ui/new_transaction/transaction_body.dart';
import 'package:finances_control/feat/transaction/ui/new_transaction/transaction_feedback.dart';
import 'package:finances_control/feat/transaction/ui/new_transaction/transaction_header.dart';
import 'package:finances_control/feat/transaction/ui/new_transaction/transaction_submit_button.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

import '../../../onboarding/ui/widgets/app_text_field.dart';
import '../transaction_label_resolver.dart';

class TransactionPage extends StatefulWidget {
  final DateTime initialDate;

  const TransactionPage({super.key, required this.initialDate});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late final FocusNode _amountFocus;

  DateTime selectedDate = DateTime.now();
  DateTime? endDate;
  TransactionType type = TransactionType.expense;
  Category category = Category.food;

  List<Category> get categories => categoryByType[type] ?? [];

  bool isRecurring = false;
  int recurringDay = 1;
  bool _isTyping = false;
  bool _hasChanges = false;
  late final AdViewModel _adViewModel;
  StreamSubscription<AdState>? _adSubscription;

  @override
  void initState() {
    super.initState();

    selectedDate = widget.initialDate;

    amountController.addListener(_onAmountChanged);
    _amountFocus = FocusNode();
    _adViewModel =
        getIt<AdViewModel>(param1: AdPlacement.newTransaction)..load();

    _adSubscription = _adViewModel.stream.listen((state) {
      if (!mounted) return;
      final shouldEnableAds = state is AdLoaded && state.shouldShow;

      context.read<TransactionViewModel>().setAdsEnabled(shouldEnableAds);

      if (shouldEnableAds) {
        context.read<TransactionViewModel>().interstitialService.loadAd();
      }
    });
  }

  @override
  void dispose() {
    amountController.removeListener(_onAmountChanged);
    amountController.dispose();
    descriptionController.dispose();
    _adSubscription?.cancel();
    _adViewModel.close();
    _amountFocus.dispose();
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

    return BlocProvider.value(
      value: _adViewModel,
      child: BlocListener<TransactionViewModel, TransactionState>(
        listener: (context, state) async {
          if (state is TransactionLoaded) {
            await _showTransactionFeedback(context, type);

            if (!mounted) return;

            setState(() {
              _hasChanges = true;
              amountController.clear();
              descriptionController.clear();
              isRecurring = false;
            });

            FocusScope.of(this.context).unfocus();
          }

          if (state is TransactionError) {
            await _onError(state);
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          bottomNavigationBar: BlocBuilder<AdViewModel, AdState>(
            builder: (context, state) {
              if (state is AdLoaded && state.shouldShow) {
                return const SafeArea(
                  top: false,
                  child: AdWidget(),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          body: Column(
            children: [
              NewTransactionHeader(
                onBack: () => Navigator.pop(context, _hasChanges),
              ),

              Expanded(
                child: TransactionBody(
                  amount: _buildAmount(),
                  typeSelector: _buildTypeSelector(),
                  category: _buildCategory(),
                  date: _buildStartDate(),
                  recurringToggle: _buildRecurringToggle(),
                  recurringSection: isRecurring
                      ? _recurringSection(theme)
                      : const SizedBox(),
                  description: _buildDescription(),
                ),
              ),

              /// 🔥 CTA BUTTON
              TransactionSubmitButton(onPressed: _save, type: type),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recurringSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        _buildRecurringDay(theme),
        const SizedBox(height: 14),
        _buildEndDate(theme),
      ],
    );
  }

  Widget _buildAmount() {
    final scheme = Theme.of(context).colorScheme;

    final Color amountColor = type == TransactionType.income
        ? const Color(0xFF5CCB7A)
        : const Color(0xFFE57373);

    return Center(
      child: AnimatedScale(
        scale: _isTyping ? 1.05 : 1,
        duration: const Duration(milliseconds: 150),
        child: TextField(
          focusNode: _amountFocus,
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
          style: TextStyle(
            fontSize: 52,
            fontWeight: FontWeight.w800,
            color: amountColor,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "R\$ 0,00",
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

  Widget _buildStartDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("📅 ${context.appStrings.date}"),
        const SizedBox(height: 12),
        AppTextField(
          hintText: DateFormat("dd MMM yyyy").format(selectedDate),
          readOnly: true,
          onTap: _pickStartDate,
        ),
      ],
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
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
      ],
    );
  }

  Widget _buildRecurringToggle() {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(context.appStrings.repeat_monthly),
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
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle("📝 ${context.appStrings.description}"),
        const SizedBox(height: 12),
        AppTextField(
          controller: descriptionController,
          hintText: context.appStrings.add_description,
        ),
      ],
    );
  }

  void _save() {
    if (context.read<TransactionViewModel>().state is TransactionLoading) {
      return;
    }

    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.appStrings.fill_the_field)),
      );
      return;
    }

    final int amount = int.parse(toNumericString(amountController.text));

    if (isRecurring) {
      final recurring = RecurringTransaction(
        amount: amount,
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
        amount: amount,
        type: type,
        category: category,
        date: selectedDate,
        description: descriptionController.text,
      );

      context.read<TransactionViewModel>().add(tx);
    }
  }

  Future<void> _onError(TransactionError state) async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.message.isNotEmpty
              ? state.message
              : context.appStrings.unexpected_error,
        ),
      ),
    );
  }

  Future<void> _showTransactionFeedback(
    BuildContext context,
    TransactionType type,
  ) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: context.appStrings.description,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, _, _) {
        return HighImpactFeedback(type: type);
      },
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
      builder: (_) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: categories.map((c) {
              return ListTile(
                leading: Text(categoryEmoji(context, c)),
                title: Text(categoryLabel(context, c)),
                onTap: () => Navigator.pop(context, c),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => category = selected);
    }
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
}
