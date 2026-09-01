import 'package:flutter/material.dart';

import '../core/app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool get darkMode =>
      AppSettings.themeMode.value == ThemeMode.dark;

  bool get medicationReminders =>
      AppSettings.medicationReminders;

  String get selectedLanguage =>
      AppSettings.locale.value.languageCode == 'ar'
          ? 'Arabic'
          : 'English';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettings.themeMode,
      builder: (context, themeMode, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),

          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [

              // ==================================================
              // APPEARANCE
              // ==================================================

              const Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: SwitchListTile(
                  secondary: const Icon(
                    Icons.dark_mode_outlined,
                  ),

                  title: const Text(
                    'Dark Mode',
                  ),

                  subtitle: const Text(
                    'Change the appearance of the application',
                  ),

                  value: darkMode,

                  onChanged: (value) {
                    AppSettings.setDarkMode(value);
                  },
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // NOTIFICATIONS
              // ==================================================

              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: SwitchListTile(
                  secondary: const Icon(
                    Icons.medication_outlined,
                  ),

                  title: const Text(
                    'Medication Reminders',
                  ),

                  subtitle: const Text(
                    'Receive reminders for your medications',
                  ),

                  value: medicationReminders,

                  onChanged: (value) {
                    setState(() {
                      AppSettings.medicationReminders = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // LANGUAGE
              // ==================================================

              const Text(
                'Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.language_outlined,
                  ),

                  title: const Text(
                    'App Language',
                  ),

                  subtitle: Text(
                    selectedLanguage,
                  ),

                  trailing: const Icon(
                    Icons.chevron_right,
                  ),

                  onTap: () {
                    _showLanguageDialog(context);
                  },
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // ABOUT
              // ==================================================

              const Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                  ),

                  title: const Text(
                    'About HELPHA',
                  ),

                  trailing: const Icon(
                    Icons.chevron_right,
                  ),

                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // LANGUAGE DIALOG
  // ============================================================

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Select Language',
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // --------------------------------------------------
              // ENGLISH
              // --------------------------------------------------

              ListTile(
                leading: Icon(
                  selectedLanguage == 'English'
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,

                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),

                title: const Text(
                  'English',
                ),

                onTap: () {
                  AppSettings.setLanguage('English');

                  Navigator.pop(dialogContext);

                  setState(() {});
                },
              ),

              // --------------------------------------------------
              // ARABIC
              // --------------------------------------------------

              ListTile(
                leading: Icon(
                  selectedLanguage == 'Arabic'
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,

                  color: Theme.of(context)
                      .colorScheme
                      .primary,
                ),

                title: const Text(
                  'Arabic',
                ),

                onTap: () {
                  AppSettings.setLanguage('Arabic');

                  Navigator.pop(dialogContext);

                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // ABOUT DIALOG
  // ============================================================

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,

      applicationName: 'HELPHA',

      applicationVersion: '1.0.0',

      applicationLegalese: '© 2026 HELPHA',

      children: const [
        SizedBox(height: 15),

        Text(
          'HELPHA is a healthcare assistance application '
          'designed to help users manage medications, '
          'schedules, notifications, and personal information.',
        ),
      ],
    );
  }
}