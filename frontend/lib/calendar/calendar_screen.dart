import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/reminder_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() =>
      _CalendarScreenState();
}

class _CalendarScreenState
    extends State<CalendarScreen> {
  final ReminderService _service =
      ReminderService();

  DateTime _selectedDate = DateTime.now();

  List<Map<String, dynamic>> _reminders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDate(_selectedDate);
  }

  Future<void> _loadDate(
    DateTime date,
  ) async {
    setState(() {
      _loading = true;
    });

    final start = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final end = DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
      999,
    );

    try {
      final reminders =
          await _service.getRange(
        start,
        end,
      );

      if (!mounted) return;

      setState(() {
        _reminders = reminders;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _reminders = [];
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  String _medicationName(
    Map<String, dynamic> reminder,
  ) {
    final medication =
        reminder['medication'];

    if (medication is Map) {
      return medication['name']?.toString() ??
          'Medication';
    }

    return 'Medication';
  }

  String _formatTime(
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return '';
    }

    try {
      final date = DateTime.parse(value)
          .toLocal();

      final hour =
          date.hour == 0 ? 12 : date.hour > 12
              ? date.hour - 12
              : date.hour;

      final minute =
          date.minute.toString().padLeft(2, '0');

      final period =
          date.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    } catch (_) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CalendarDatePicker(
            initialDate: _selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });

              _loadDate(date);
            },
          ),

          const SizedBox(height: 20),

          Text(
            'Medications',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontWeight:
                      FontWeight.bold,
                ),
          ),

          const SizedBox(height: 12),

          if (_loading)
            const Center(
              child:
                  CircularProgressIndicator(),
            )
          else if (_reminders.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No medications scheduled for this date.',
                ),
              ),
            )
          else
            ..._reminders.map(
              (reminder) {
                final status =
                    reminder['status']
                            ?.toString()
                            .toUpperCase() ??
                        'PENDING';

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          AppColors.primary
                              .withValues(
                        alpha: 0.10,
                      ),
                      child: const Icon(
                        Icons.medication,
                        color:
                            AppColors.primary,
                      ),
                    ),
                    title: Text(
                      _medicationName(
                        reminder,
                      ),
                    ),
                    subtitle: Text(
                      '${_formatTime(reminder['scheduledAt']?.toString())} • $status',
                    ),
                    trailing:
                        status == 'TAKEN'
                            ? const Icon(
                                Icons.check_circle,
                                color:
                                    AppColors.success,
                              )
                            : null,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}