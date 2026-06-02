# In-App Update — Implementation Guide

Check for available app updates and offer them to the user without forcing an interruption. All update flows are **optional (flexible)** — the user can dismiss and continue using the app.

---

## Update Strategy

Only **flexible updates** are implemented. The user sees a native bottom sheet, can start the download in the background, and applies the update when convenient. There is no blocking "immediate update" gate.

| Type | Behavior | Used here |
|---|---|---|
| Flexible | Download in background, user applies when ready | Yes |
| Immediate | Fullscreen block, user must update before continuing | No |

---

## Package

```yaml
# pubspec.yaml
dependencies:
  in_app_update: ^4.2.3   # Android — Google Play In-App Updates API
```

> **iOS**: The Google Play In-App Updates API is Android-only. On iOS, the recommended approach is to silently check the App Store for a newer version and show a custom dialog (using `upgrader: ^30.0.0` or a manual App Store API check). The service interface below is designed to support both platforms behind a common contract.

---

## Architecture

Lives under `lib/core/services/` — it is a cross-cutting infrastructure concern, not a feature.

```
lib/core/services/
  update/
    update_service.dart          ← abstract interface
    update_service_impl.dart     ← Android: in_app_update; iOS: stub or upgrader
    update_service_stub.dart     ← no-op for unsupported platforms / tests
```

---

## 1. Abstract Interface

```dart
// lib/core/services/update/update_service.dart
abstract class UpdateService {
  /// Checks for an available update and presents the flexible update flow
  /// if one is found. Safe to call on every app start — the underlying
  /// platform APIs handle rate-limiting and caching.
  Future<void> checkForUpdate();
}
```

---

## 2. Android Implementation

```dart
// lib/core/services/update/update_service_impl.dart
import 'dart:io';
import 'package:in_app_update/in_app_update.dart';

class UpdateServiceImpl implements UpdateService {
  @override
  Future<void> checkForUpdate() async {
    if (!Platform.isAndroid) return;

    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.startFlexibleUpdate();
        // The download happens in the background.
        // Call InAppUpdate.completeFlexibleUpdate() when ready to apply.
        // See section 4 for the completion trigger.
      }
    } catch (_) {
      // Update checks are best-effort — never crash the app over them.
    }
  }
}
```

Errors are silently swallowed because a failed update check must never surface to the user.

---

## 3. Stub (iOS + Tests)

```dart
// lib/core/services/update/update_service_stub.dart
class UpdateServiceStub implements UpdateService {
  @override
  Future<void> checkForUpdate() async {}
}
```

---

## 4. Applying a Completed Flexible Update

After a flexible update finishes downloading, call `completeFlexibleUpdate()` to apply it. The best moment is when the user navigates away from an active screen or explicitly dismisses a "Restart to update" banner.

A minimal in-app banner approach using `InAppUpdate.installUpdateListener`:

```dart
// Example snippet — add to HomePage or a root-level widget
import 'package:in_app_update/in_app_update.dart';

StreamSubscription<InstallStatus>? _updateSubscription;

@override
void initState() {
  super.initState();
  if (Platform.isAndroid) {
    _updateSubscription = InAppUpdate.installUpdateListener.listen((status) {
      if (status == InstallStatus.downloaded && mounted) {
        _showRestartSnackbar();
      }
    });
  }
}

void _showRestartSnackbar() {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(context.appStrings.updateReadyToInstall),
      action: SnackBarAction(
        label: context.appStrings.restart,
        onPressed: () => InAppUpdate.completeFlexibleUpdate(),
      ),
      duration: const Duration(seconds: 10),
    ),
  );
}

@override
void dispose() {
  _updateSubscription?.cancel();
  super.dispose();
}
```

Add the required localization keys (`updateReadyToInstall`, `restart`) to every `.arb` file before running `flutter gen-l10n`.

---

## 5. DI Registration

```dart
// lib/core/services/update/update_service_injection.dart  (or inline in setup_locator.dart)
import 'dart:io';

void updateServiceInjection() {
  getIt.registerLazySingleton<UpdateService>(
    () => Platform.isAndroid ? UpdateServiceImpl() : UpdateServiceStub(),
  );
}
```

Call `updateServiceInjection()` from `lib/core/di/setup_locator.dart` inside `setupLocator()`.

---

## 6. Triggering the Check

Call `checkForUpdate()` once per session, after DI is ready and before the first frame is shown:

```dart
// lib/main.dart — inside the main() / runApp initialization block
await setupLocator();
await getIt<UpdateService>().checkForUpdate();
runApp(const App());
```

Alternatively, trigger it from `HomeViewModel.load()` if you prefer to defer until the Home screen is first shown (slightly later, avoids any cold-start latency impact):

```dart
// HomeViewModel.load() — fire-and-forget, do not await
getIt<UpdateService>().checkForUpdate();
```

Both approaches are valid. The `main.dart` placement is simpler; the ViewModel placement keeps the main entry point clean.

---

## 7. Testing

Mock `UpdateService` in unit tests — the stub already satisfies the interface:

```dart
class _MockUpdateService extends Mock implements UpdateService {}

test('check is called on load', () async {
  final updateService = _MockUpdateService();
  when(() => updateService.checkForUpdate()).thenAnswer((_) async {});

  // inject and call...

  verify(() => updateService.checkForUpdate()).called(1);
});
```

Never test the `InAppUpdate` plugin calls directly — treat them as infrastructure and mock at the service boundary.

---

## Platform Notes

| Platform | Package | Update dialog |
|---|---|---|
| Android | `in_app_update` | Google Play native bottom sheet |
| iOS | `upgrader` (optional) | Custom dialog checking App Store version JSON |

### iOS with `upgrader`

If iOS update prompts are needed in the future:

```yaml
dependencies:
  upgrader: ^30.0.0
```

Wrap `MaterialApp` with `UpgradeAlert` and set `daysUntilAlertAgain: 0` to delegate frequency control to the service layer. All prompts remain dismissible.

---

## Checklist

- [ ] Add `in_app_update` to `pubspec.yaml`
- [ ] Create `UpdateService` abstract class in `lib/core/services/update/`
- [ ] Create `UpdateServiceImpl` (Android) and `UpdateServiceStub`
- [ ] Register in `setup_locator.dart`
- [ ] Call `checkForUpdate()` from `main.dart` or `HomeViewModel`
- [ ] Add restart SnackBar listener in `HomePage` for downloaded flexible updates
- [ ] Add localization strings: `updateReadyToInstall`, `restart`
- [ ] Verify on a device connected to a Play Store track (internal/alpha)
