import 'package:finances_control/components/default_header.dart';
import 'package:flutter/material.dart';

class NewTransactionHeader extends StatelessWidget {
  final VoidCallback onBack;

  const NewTransactionHeader({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      title: 'Nova Transação',
      subtitle: 'Preencha os dados',
      type: HeaderType.neutral,
      onBack: onBack,
    );
  }
}