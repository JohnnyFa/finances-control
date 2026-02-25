import 'dart:math';
import 'package:finances_control/feat/home/domain/enum_balance_mood.dart';
import 'package:flutter/material.dart';

class AnimatedBalanceEmoji extends StatefulWidget {
  final BalanceMood mood;
  final double intensity;

  const AnimatedBalanceEmoji({
    super.key,
    required this.mood,
    required this.intensity,
  });

  @override
  State<AnimatedBalanceEmoji> createState() =>
      _AnimatedBalanceEmojiState();
}

class _AnimatedBalanceEmojiState extends State<AnimatedBalanceEmoji>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: (1200 ~/ (widget.intensity.abs() + 0.5)).clamp(400, 1400),
      ),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedBalanceEmoji oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mood != widget.mood ||
        oldWidget.intensity != widget.intensity) {
      _controller.duration = Duration(
        milliseconds:
        (1200 ~/ (widget.intensity.abs() + 0.5)).clamp(400, 1400),
      );
      _controller.reset();
      _controller.repeat(reverse: true);
    }
  }

  String get emoji {
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

  Color get glowColor {
    switch (widget.mood) {
      case BalanceMood.superHappy:
        return Colors.orangeAccent;
      case BalanceMood.happy:
        return Colors.greenAccent;
      case BalanceMood.neutral:
        return Colors.grey;
      case BalanceMood.sad:
        return Colors.blueGrey;
      case BalanceMood.verySad:
        return Colors.redAccent;
      case BalanceMood.melting:
        return Colors.deepOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        double bounce = 0;
        double rotate = 0;
        double shake = 0;

        switch (widget.mood) {
          case BalanceMood.superHappy:
            bounce = -8 * _controller.value;
            break;

          case BalanceMood.happy:
            bounce = -4 * _controller.value;
            break;

          case BalanceMood.neutral:
            bounce = 0;
            break;

          case BalanceMood.sad:
            bounce = 3 * _controller.value;
            break;

          case BalanceMood.verySad:
            shake = sin(_controller.value * 20) * 6;
            break;

          case BalanceMood.melting:
            bounce = 6 * _controller.value;
            rotate = _controller.value * 0.1;
            break;
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            if (widget.mood == BalanceMood.superHappy)
              Positioned(
                bottom: 20,
                child: Opacity(
                  opacity: 0.5 + _controller.value * 0.5,
                  child: const Text("🔥", style: TextStyle(fontSize: 20)),
                ),
              ),

            Transform.translate(
              offset: Offset(shake, bounce),
              child: Transform.rotate(
                angle: rotate,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: glowColor.withValues(
                          alpha: 0.4 + 0.4 * _controller.value,
                        ),
                        blurRadius: 16 + 10 * widget.intensity.abs(),
                      ),
                    ],
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 44),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}