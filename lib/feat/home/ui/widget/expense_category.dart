import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';

Widget expenseCategoryTile(
    BuildContext context, {
      required Category category,
      required int percent,
      required String amount,
    }) {
  final theme = Theme.of(context);

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: theme.colorScheme.surface,
      boxShadow: const [
        BoxShadow(
          blurRadius: 6,
          offset: Offset(0, 2),
          color: Colors.black12,
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🔵 Bullet
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: category.color,
          ),
        ),
        const SizedBox(width: 12),

        // 📄 Conteúdo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    description: category.label,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              CustomText(
                description: amount,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),

        // 📊 Percentual
        CustomText(
          description: '$percent%',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: category.color,
        ),
      ],
    ),
  );
}
