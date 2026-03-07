import 'package:flutter/material.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';

class ThemeTile extends StatelessWidget {
  final String icon;
  final String title;
  final bool selected;

  const ThemeTile({
    required this.icon,
    required this.title,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? scheme.primary : scheme.outline.withValues(alpha: 0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [

          Text(icon, style: const TextStyle(fontSize: 26)),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          if (selected)
            Icon(Icons.check_circle, color: scheme.primary)
          else
            Icon(Icons.circle_outlined, color: scheme.onSurface.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}