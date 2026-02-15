import 'package:finances_control/core/extensions/app_extensions.dart';
import 'package:finances_control/core/route/path/app_route_path.dart';
import 'package:finances_control/core/route/route_observer.dart';
import 'package:finances_control/core/services/navigator_service.dart';
import 'package:finances_control/core/theme/app_theme.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/setup_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await getIt.allReady();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: MaterialApp(
            title: "Monity",
            debugShowCheckedModeBanner: false,
            navigatorObservers: [routeObserver],
            onGenerateRoute: (settings) {
              final WidgetBuilder? widgetBuilder = appRoutes[settings.name];
              if (widgetBuilder == null) return null;
              return MaterialPageRoute(
                builder: (context) => Container(child: widgetBuilder(context)),
                settings: settings,
              );
            },
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            navigatorKey: NavigationService.navigationKey,
            initialRoute: AppRoutePath.appStart.path,
            themeMode: ThemeMode.system,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('pt', 'BR'), Locale('en')],
          ),
        );
      },
    );
  }
}
