import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final BorderRadiusGeometry borderRadius;
  final Color? color;
  final Gradient? gradient;

  const HomeCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 6,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.color,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: gradient != null
          ? BoxDecoration(gradient: gradient, borderRadius: borderRadius)
          : null,
      child: Material(
        elevation: elevation,
        color: gradient != null ? Colors.transparent : color,
        borderRadius: borderRadius,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
