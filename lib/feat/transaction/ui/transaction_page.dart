import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String type = "Expense";
  String category = "Food";

  final incomeCategories = [
    "Salary",
    "Bonus",
    "Freelance",
    "Investment",
    "Others",
  ];
  final expenseCategories = [
    "Food",
    "Transport",
    "Rent",
    "Shopping",
    "Health",
    "Entertainment",
    "Others",
  ];

  List<String> get categories =>
      type == "Income" ? incomeCategories : expenseCategories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: CustomText(
          description: "New Transaction",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: CustomText(
                description: "Save",
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimary,
              ),
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
    );
  }

  Widget _buildAmount(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.attach_money,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: "0.00",
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
        _typeButton("Income", const Color(0xFF6BD49F)),
        const SizedBox(width: 12),
        _typeButton("Expense", const Color(0xFFFF6B6B)),
      ],
    );
  }

  Widget _typeButton(String value, Color color) {
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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? color : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomText(
              description: value,
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
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButton<String>(
            value: category,
            isExpanded: true,
            dropdownColor: theme.cardColor,
            underline: const SizedBox(),
            style: TextStyle(color: theme.colorScheme.onSurface),
            items: categories
                .map(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: CustomText(
                      description: c,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => category = value!),
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
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
              hintText: "Description",
              hintStyle: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
        color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
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
    final amount = double.tryParse(amountController.text) ?? 0;

    debugPrint("""
NEW TRANSACTION
Type: $type
Category: $category
Amount: $amount
Date: $selectedDate
Description: ${descriptionController.text}
""");

    Navigator.pop(context);
  }
}
