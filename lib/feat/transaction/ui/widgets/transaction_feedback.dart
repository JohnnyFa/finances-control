import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';

class HighImpactFeedback extends StatefulWidget {
  final TransactionType type;

  const HighImpactFeedback({super.key, required this.type});

  @override
  State<HighImpactFeedback> createState() => _HighImpactFeedbackState();
}

class _HighImpactFeedbackState extends State<HighImpactFeedback>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _backgroundFade;
  late final Animation<double> _emojiScale;
  late final Animation<Offset> _emojiSlide;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _backgroundFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    _emojiScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _emojiSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
          ),
        );

    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
          ),
        );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1500), () async {
      _controller.reverseDuration;
      if (mounted) Navigator.of(context).pop();
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

    final backgroundColor = isIncome
        ? const Color(0xFF5CCB7A)
        : const Color(0xFFE57373);

    final emoji = isIncome ? "🎉💰" : "💸😬";

    final message = isIncome
        ? context.appStrings.income_added
        : context.appStrings.expense_added;

    return Material(
      child: FadeTransition(
        opacity: _backgroundFade,
        child: Container(
          color: backgroundColor.withValues(alpha: 0.95),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SlideTransition(
                  position: _emojiSlide,
                  child: ScaleTransition(
                    scale: _emojiScale,
                    child: Text(emoji, style: const TextStyle(fontSize: 96)),
                  ),
                ),
                const SizedBox(height: 24),
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
