import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';

Widget incomeExpenseCard(BuildContext context, String title, int value) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF9D7BFF), Color(0xFF7B3FF6)],
        ),
      ),
      child: Column(
        children: [
          CustomText(description: title, color: Colors.white, fontSize: 12),
          CustomText(
            description: formatCurrencyFromCents(context, value),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}
