
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class HelphaApp extends StatefulWidget {
  const HelphaApp({super.key});

  @override
  State<HelphaApp> createState() => _HelphaAppState();
}

class _HelphaAppState extends State<HelphaApp> {
  bool isDarkMode = false;

  void changeTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HELPHA',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const SplashScreen(),
    );
  }
}
