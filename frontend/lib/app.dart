import 'package:flutter/material.dart';

import 'core/app_settings.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class HelphaApp extends StatelessWidget {
  const HelphaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable:
          AppSettings.themeMode,
      builder:
          (context, themeMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable:
              AppSettings.locale,
          builder:
              (context, locale, _) {
            return MaterialApp(
              debugShowCheckedModeBanner:
                  false,
              title: 'HELPHA',
              theme:
                  AppTheme.lightTheme,
              darkTheme:
                  AppTheme.darkTheme,
              themeMode: themeMode,
              locale: locale,
              home:
                  const SplashScreen(),
            );
          },
        );
      },
    );
  }
}