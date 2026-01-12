import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'core/services/navigator_service.dart';

class AppStrings {
  static AppLocalizations of(BuildContext context) => AppLocalizations.of(context)!;

  AppLocalizations get l10n => AppLocalizations.of(NavigationService.navigationKey.currentContext!)!;
}