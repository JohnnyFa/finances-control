import 'dart:async';
import 'dart:ui';

import 'package:finances_control/core/crashlytics/crashlytics_service.dart';
import 'package:finances_control/core/extensions/app_extensions.dart';
import 'package:finances_control/core/logger/app_logger.dart';
import 'package:finances_control/core/observer/app_bloc_observer.dart';
import 'package:finances_control/core/route/path/app_route_path.dart';
import 'package:finances_control/core/route/route_observer.dart';
import 'package:finances_control/core/services/analytics_service.dart';
import 'package:finances_control/core/services/navigator_service.dart';
import 'package:finances_control/core/shared_preferences/app_preferences.dart';
import 'package:finances_control/core/theme/app_theme.dart';
import 'package:finances_control/feat/premium/presentation/init/purchase_initializer.dart';
import 'package:finances_control/feat/profile/screens/preferences/vm/preferences_state.dart';
import 'package:finances_control/feat/profile/screens/preferences/vm/preferences_vm.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/di/setup_locator.dart';

Future<void> mainApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Future.wait([
    setupLocator(),
    AppPreferences.init(),
  ]);

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    !kDebugMode,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    final crashlyticsService = getIt<CrashlyticsService>();
    crashlyticsService.recordError(
      details.exception,
      details.stack,
      reason: 'Unhandled Flutter framework error',
      fatal: true,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    final crashlyticsService = getIt<CrashlyticsService>();
    crashlyticsService.recordError(
      error,
      stack,
      reason: 'Unhandled platform dispatcher error',
      fatal: true,
    );
    if (kDebugMode) {
      return false;
    }
    return true;
  };

  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
    AppLogger.info('App starting — debug tracking enabled');
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    BlocProvider(
      create: (_) => getIt<PreferencesViewModel>(),
      child: const MyApp(),
    ),
  );

  unawaited(_runDeferredInitializations());
}

Future<void> _runDeferredInitializations() async {
  final crashlyticsService = getIt<CrashlyticsService>();

  try {
    await MobileAds.instance.initialize();
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize Google Mobile Ads: $e');
    await crashlyticsService.recordUnexpectedError(
      e,
      stackTrace,
      'Unexpected failure while initializing Google Mobile Ads SDK',
    );
  }

  try {
    await Future.wait([
      getIt<PurchaseInitializer>().init(),
      getIt<AnalyticsService>().logAppOpen(),
    ]);
  } catch (e, stackTrace) {
    await crashlyticsService.recordUnexpectedError(
      e,
      stackTrace,
      'Unexpected failure during deferred startup tasks',
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesViewModel, PreferencesState>(
      builder: (context, state) {
        ThemeMode themeMode = ThemeMode.system;

        if (state is PreferencesLoaded) {
          themeMode = state.themeMode;
        }

        return Builder(
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: MaterialApp(
                title: "Monity",
                debugShowCheckedModeBanner: false,
                navigatorObservers: [routeObserver],
                onGenerateRoute: (settings) {
                  final WidgetBuilder? widgetBuilder = appRoutes[settings.name];
                  if (widgetBuilder == null) return null;

                  return MaterialPageRoute(
                    builder: (context) => widgetBuilder(context),
                    settings: settings,
                  );
                },
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),

                /// 👇 agora reage ao cubit
                themeMode: themeMode,
                navigatorKey: NavigationService.navigationKey,
                initialRoute: AppRoutePath.appStart.path,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('pt', 'BR'), Locale('en')],
              ),
            );
          },
        );
      },
    );
  }
}
