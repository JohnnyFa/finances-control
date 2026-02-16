import 'package:finances_control/feat/home/domain/enum_balance_mood.dart';
import 'package:flutter/material.dart';

class AnimatedBalanceEmoji extends StatefulWidget {
  final BalanceMood mood;

  const AnimatedBalanceEmoji({super.key, required this.mood});

  @override
  State<AnimatedBalanceEmoji> createState() => _AnimatedBalanceEmojiState();
}

class _AnimatedBalanceEmojiState extends State<AnimatedBalanceEmoji>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant AnimatedBalanceEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood) {
      _controller.reset();
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _emoji {
    switch (widget.mood) {
      case BalanceMood.superHappy:
        return "🤩";
      case BalanceMood.happy:
        return "😊";
      case BalanceMood.neutral:
        return "😐";
      case BalanceMood.sad:
        return "😔";
      case BalanceMood.verySad:
        return "😡";
      case BalanceMood.melting:
        return "🫠";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        double offset = 0;

        switch (widget.mood) {
          case BalanceMood.superHappy:
            offset = -6 * _controller.value;
            break;

          case BalanceMood.happy:
            offset = -3 * _controller.value;
            break;

          case BalanceMood.neutral:
            offset = 0;
            break;

          case BalanceMood.sad:
            offset = 2 * _controller.value;
            break;

          case BalanceMood.verySad:
            offset = 4 * _controller.value;
            break;

          case BalanceMood.melting:
            offset = 8 * _controller.value;
            break;
        }

        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: Text(
        _emoji,
        style: const TextStyle(fontSize: 42),
      ),
    );
  }
}
