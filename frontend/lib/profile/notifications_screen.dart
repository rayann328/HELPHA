import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool medicationReminders = true;
  bool scheduleReminders = true;
  bool generalNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: SwitchListTile(
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

          const SizedBox(height: 10),

          Card(
            child: SwitchListTile(
              title: const Text('Schedule Reminders'),
              subtitle: const Text(
                'Receive reminders about your schedule',
              ),
              value: scheduleReminders,
              onChanged: (value) {
                setState(() {
                  scheduleReminders = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: SwitchListTile(
              title: const Text('General Notifications'),
              subtitle: const Text(
                'Receive general app notifications',
              ),
              value: generalNotifications,
              onChanged: (value) {
                setState(() {
                  generalNotifications = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}