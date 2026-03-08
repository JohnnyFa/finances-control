import 'package:finances_control/core/extensions/app_extensions.dart';
import 'package:finances_control/core/logger/app_logger.dart';
import 'package:finances_control/core/observer/app_bloc_observer.dart';
import 'package:finances_control/core/route/path/app_route_path.dart';
import 'package:finances_control/core/route/route_observer.dart';
import 'package:finances_control/core/services/navigator_service.dart';
import 'package:finances_control/core/shared_preferences/app_preferences.dart';
import 'package:finances_control/core/theme/app_theme.dart';
import 'package:finances_control/feat/profile/screens/preferences/vm/preferences_state.dart';
import 'package:finances_control/feat/profile/screens/preferences/vm/preferences_vm.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/setup_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
    AppLogger.info('App starting — debug tracking enabled');
  }
  await AppPreferences.init();
  await setupLocator();
  await getIt.allReady();
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

                supportedLocales: const [
                  Locale('pt', 'BR'),
                  Locale('en'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}