import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String errorMessage;

  const ErrorText({required this.errorMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        errorMessage,
        style: TextStyle(
          color: Theme
              .of(context)
              .colorScheme
              .error,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}