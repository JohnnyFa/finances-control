import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestorePurchasesButton extends StatelessWidget {
  const RestorePurchasesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<PurchaseViewModel>().restore();
      },
      child: const Text('Restaurar compras'),
    );
  }
}