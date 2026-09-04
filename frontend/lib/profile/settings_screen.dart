import 'package:flutter/material.dart';

import '../core/app_settings.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  final SettingsService _service =
      SettingsService();

  bool _darkMode = false;
  bool _medicationReminders = true;
  String _language = 'en';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings =
          await _service.getSettings();

      if (!mounted) return;

      final darkMode =
          settings['darkMode'] ?? false;

      final language =
          settings['language']?.toString() ??
              'en';

      final reminders =
          settings['medicationReminders'] ??
              true;

      setState(() {
        _darkMode = darkMode;
        _language = language;
        _medicationReminders = reminders;
        _loading = false;
      });

      AppSettings.setDarkMode(darkMode);

      AppSettings.locale.value =
          language == 'ar'
              ? const Locale('ar')
              : const Locale('en');

      AppSettings.medicationReminders =
          reminders;
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _setDarkMode(
    bool value,
  ) async {
    setState(() {
      _darkMode = value;
    });

    AppSettings.setDarkMode(value);

    try {
      await _service.updateSettings(
        darkMode: value,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _darkMode = !value;
      });

      AppSettings.setDarkMode(!value);
    }
  }

  Future<void> _setLanguage(
    String value,
  ) async {
    setState(() {
      _language = value;
    });

    AppSettings.locale.value =
        value == 'ar'
            ? const Locale('ar')
            : const Locale('en');

    try {
      await _service.updateSettings(
        language: value,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _setMedicationReminders(
    bool value,
  ) async {
    setState(() {
      _medicationReminders = value;
    });

    AppSettings.medicationReminders =
        value;

    try {
      await _service.updateSettings(
        medicationReminders: value,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _medicationReminders = !value;
      });

      AppSettings.medicationReminders =
          !value;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'HELPHA',
      applicationVersion: '1.0.0',
      applicationLegalese:
          'Medication and health management application',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Dark mode'),
              subtitle: const Text(
                'Use dark appearance throughout the app',
              ),
              value: _darkMode,
              onChanged: _setDarkMode,
            ),
          ),

          Card(
            child: SwitchListTile(
              title:
                  const Text('Medication reminders'),
              subtitle: const Text(
                'Enable medication reminders',
              ),
              value: _medicationReminders,
              onChanged:
                  _setMedicationReminders,
            ),
          ),

          Card(
            child: ListTile(
              title: const Text('Language'),
              subtitle: Text(
                _language == 'ar'
                    ? 'Arabic'
                    : 'English',
              ),
              trailing:
                  DropdownButton<String>(
                value: _language,
                items: const [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('Arabic'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _setLanguage(value);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: ListTile(
              leading:
                  const Icon(Icons.info_outline),
              title: const Text('About HELPHA'),
              trailing:
                  const Icon(Icons.chevron_right),
              onTap: _showAbout,
            ),
          ),
        ],
      ),
    );
  }
}