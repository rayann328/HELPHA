import 'package:flutter/material.dart';
import '../core/app_settings.dart';
import '../core/localization/app_strings.dart';
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
          settings['language']?.toString() ?? 'en';
      final reminders =
          settings['medicationReminders'] ?? true;
      setState(() {
        _darkMode = darkMode == true;
        _language = language;
        _medicationReminders = reminders == true;
        _loading = false;
      });
      AppSettings.setDarkMode(
        _darkMode,
      );
      AppSettings.locale.value =
          _language == 'ar'
              ? Locale('ar')
              : Locale('en');
      AppSettings.medicationReminders =
          _medicationReminders;
    } catch (_) {
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
    } catch (_) {
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
    // Change app language immediately.
    AppSettings.locale.value =
        value == 'ar'
            ? Locale('ar')
            : Locale('en');
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
    final arabic =
        AppStrings.isArabic(context);
    showAboutDialog(
      context: context,
      applicationName: 'HELPHA',
      applicationVersion: '1.0.0',
      applicationLegalese: arabic
          ? 'تطبيق لإدارة الأدوية والصحة'
          : 'Medication and health management application',
    );
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.get(
            context,
            'settings',
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // ----------------------------------------------------
          // DARK MODE
          // ----------------------------------------------------
          Card(
            child: SwitchListTile(
              title: Text(
                AppStrings.get(
                  context,
                  'darkMode',
                ),
              ),
              subtitle: Text(
                AppStrings.get(
                  context,
                  'darkModeDescription',
                ),
              ),
              value: _darkMode,
              onChanged: _setDarkMode,
            ),
          ),
          // ----------------------------------------------------
          // MEDICATION REMINDERS
          // ----------------------------------------------------
          Card(
            child: SwitchListTile(
              title: Text(
                AppStrings.get(
                  context,
                  'medicationReminders',
                ),
              ),
              subtitle: Text(
                AppStrings.get(
                  context,
                  'medicationRemindersDescription',
                ),
              ),
              value: _medicationReminders,
              onChanged:
                  _setMedicationReminders,
            ),
          ),
          // ----------------------------------------------------
          // LANGUAGE
          // ----------------------------------------------------
          Card(
            child: ListTile(
              title: Text(
                AppStrings.get(
                  context,
                  'language',
                ),
              ),
              subtitle: Text(
                _language == 'ar'
                    ? AppStrings.get(
                        context,
                        'arabic',
                      )
                    : AppStrings.get(
                        context,
                        'english',
                      ),
              ),
              trailing:
                  DropdownButton<String>(
                value: _language,
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(
                      AppStrings.get(
                        context,
                        'english',
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text(
                      AppStrings.get(
                        context,
                        'arabic',
                      ),
                    ),
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
          SizedBox(height: 16),
          // ----------------------------------------------------
          // ABOUT
          // ----------------------------------------------------
          Card(
            child: ListTile(
              leading:
                  Icon(
                Icons.info_outline,
              ),
              title: Text(
                AppStrings.get(
                  context,
                  'aboutHelpha',
                ),
              ),
              trailing:
                  Icon(
                Icons.chevron_right,
              ),
              onTap: _showAbout,
            ),
          ),
        ],
      ),
    );
  }
}