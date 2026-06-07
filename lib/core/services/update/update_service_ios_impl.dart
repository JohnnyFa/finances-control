import 'dart:io';

import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/services/navigator_service.dart';
import 'package:finances_control/core/services/update/update_service.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpdateServiceIosImpl implements UpdateService {
  final Upgrader _upgrader = Upgrader(durationUntilAlertAgain: Duration.zero);
  bool _promptedThisSession = false;

  @override
  Future<void> checkForUpdate() async {
    if (!Platform.isIOS) return;
    if (_promptedThisSession) return;

    try {
      await _upgrader.initialize();

      if (!_upgrader.shouldDisplayUpgrade()) return;

      final context = NavigationService.navigationKey.currentContext;
      if (context == null || !context.mounted) return;

      _promptedThisSession = true;

      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _UpdateBottomSheet(upgrader: _upgrader),
      );
    } catch (_) {
      // Update checks are best-effort — never crash the app over them.
    }
  }
}

class _UpdateBottomSheet extends StatelessWidget {
  const _UpdateBottomSheet({required this.upgrader});

  final Upgrader upgrader;

  @override
  Widget build(BuildContext context) {
    final releaseNotes = upgrader.releaseNotes;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.appStrings.updateAvailableTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(context.appStrings.updateAvailableMessage),
            if (releaseNotes != null && releaseNotes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                context.appStrings.whatsNew,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: SingleChildScrollView(
                  child: Text(releaseNotes),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await upgrader.saveLastAlerted();
                await upgrader.sendUserToAppStore();
              },
              child: Text(context.appStrings.updateNow),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await upgrader.saveLastAlerted();
              },
              child: Text(context.appStrings.remindMeLater),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await upgrader.saveIgnored();
              },
              child: Text(context.appStrings.dismissUpdate),
            ),
          ],
        ),
      ),
    );
  }
}
