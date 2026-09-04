import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/settings_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  final SettingsService _service =
      SettingsService();

  bool _medicationReminders = true;
  bool _notificationSound = true;
  bool _vibration = true;

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

      setState(() {
        _medicationReminders =
            settings['medicationReminders'] ??
                true;

        _notificationSound =
            settings['notificationSound'] ??
                true;

        _vibration =
            settings['vibration'] ?? true;

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _update({
    bool? medicationReminders,
    bool? notificationSound,
    bool? vibration,
  }) async {
    final oldMedication =
        _medicationReminders;
    final oldSound = _notificationSound;
    final oldVibration = _vibration;

    setState(() {
      if (medicationReminders != null) {
        _medicationReminders =
            medicationReminders;
      }

      if (notificationSound != null) {
        _notificationSound =
            notificationSound;
      }

      if (vibration != null) {
        _vibration = vibration;
      }
    });

    try {
      await _service.updateSettings(
        medicationReminders:
            medicationReminders,
        notificationSound:
            notificationSound,
        vibration: vibration,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _medicationReminders =
            oldMedication;
        _notificationSound = oldSound;
        _vibration = oldVibration;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
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
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Notification Preferences',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: SwitchListTile(
              secondary: const Icon(
                Icons.medication,
                color: AppColors.primary,
              ),
              title:
                  const Text('Medication reminders'),
              subtitle: const Text(
                'Receive reminders for your medications',
              ),
              value: _medicationReminders,
              onChanged: (value) {
                _update(
                  medicationReminders: value,
                );
              },
            ),
          ),

          Card(
            child: SwitchListTile(
              secondary: const Icon(
                Icons.volume_up,
                color: AppColors.primary,
              ),
              title:
                  const Text('Notification sound'),
              subtitle: const Text(
                'Play a sound for notifications',
              ),
              value: _notificationSound,
              onChanged: (value) {
                _update(
                  notificationSound: value,
                );
              },
            ),
          ),

          Card(
            child: SwitchListTile(
              secondary: const Icon(
                Icons.vibration,
                color: AppColors.primary,
              ),
              title: const Text('Vibration'),
              subtitle: const Text(
                'Vibrate when a notification arrives',
              ),
              value: _vibration,
              onChanged: (value) {
                _update(
                  vibration: value,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}