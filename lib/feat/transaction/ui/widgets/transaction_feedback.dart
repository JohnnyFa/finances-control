import 'package:flutter/material.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';

class TransactionFeedbackPage extends StatefulWidget {
  final TransactionType type;

  const TransactionFeedbackPage({
    super.key,
    required this.type,
  });

  @override
  State<TransactionFeedbackPage> createState() =>
      _TransactionFeedbackPageState();
}

class _TransactionFeedbackPageState extends State<TransactionFeedbackPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _slide = Tween<Offset>(
      begin: widget.type == TransactionType.income
          ? const Offset(0, 0.3)
          : const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = widget.type == TransactionType.income;

    return Scaffold(
      backgroundColor: isIncome
          ? const Color(0xFF1DB954)
          : const Color(0xFFE53935),
      body: Center(
        child: SlideTransition(
          position: _slide,
          child: ScaleTransition(
            scale: _scale,
            child: Text(
              isIncome ? '😄💰' : '😞💸',
              style: const TextStyle(fontSize: 96),
            ),
          ),
        ),
      ),
    );
  }
}
