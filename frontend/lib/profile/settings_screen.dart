import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool medicationReminders = true;

  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Appearance
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
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark Mode'),
              subtitle: const Text(
                'Change the appearance of the application',
              ),
              value: darkMode,
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),
          ),

          const SizedBox(height: 25),

          // Notifications
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
              title: const Text('Medication Reminders'),
              subtitle: const Text(
                'Receive reminders for your medications',
              ),
              value: medicationReminders,
              onChanged: (value) {
                setState(() {
                  medicationReminders = value;
                });
              },
            ),
          ),

          const SizedBox(height: 25),

          // Language
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
              title: const Text('App Language'),
              subtitle: Text(selectedLanguage),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
          ),

          const SizedBox(height: 25),

          // About
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
              title: const Text('About HELPHA'),
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
  }
void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                selectedLanguage == 'English'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              title: const Text('English'),
              onTap: () {
                setState(() {
                  selectedLanguage = 'English';
                });

                Navigator.pop(dialogContext);
              },
            ),
            ListTile(
              leading: Icon(
                selectedLanguage == 'Arabic'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
              ),
              title: const Text('Arabic'),
              onTap: () {
                setState(() {
                  selectedLanguage = 'Arabic';
                });

                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      );
    },
  );
}
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