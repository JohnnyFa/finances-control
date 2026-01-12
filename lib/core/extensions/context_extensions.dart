import 'package:finances_control/l10n/app_localizations.dart';
import 'package:finances_control/l10n_helper.dart';
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  AppLocalizations get appStrings {
    return AppStrings.of(this);
  }
}