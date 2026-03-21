import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../viewmodel/transaction_viewmodel.dart';
import '../../viewmodel/transaction_state.dart';
import '../../domain/enum_transaction.dart';

class TransactionSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final TransactionType type;

  const TransactionSubmitButton({
    super.key,
    required this.onPressed,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final loading =
    context.watch<TransactionViewModel>().state is TransactionLoading;

    final color = type == TransactionType.income
        ? const Color(0xFF22C55E)
        : const Color(0xFFE57373);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: loading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: loading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text(
              'Adicionar Transação',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}