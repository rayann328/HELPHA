import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class HelphaApp extends StatelessWidget {
  const HelphaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HELPHA',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}