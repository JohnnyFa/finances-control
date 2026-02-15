import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final TextAlign textAlign;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;

  final int? maxLines;
  final int? minLines;
  final bool expands;

  const AppTextField({
    super.key,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      textAlign: textAlign,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: expands ? null : maxLines,
      minLines: minLines,
      expands: expands,
      style: style ??
          theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.1),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: scheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}