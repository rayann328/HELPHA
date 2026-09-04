import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/reminder_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() =>
      _ScheduleScreenState();
}

class _ScheduleScreenState
    extends State<ScheduleScreen> {
  final ReminderService _service =
      ReminderService();

  List<Map<String, dynamic>> _reminders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  Future<void> _loadToday() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final reminders =
          await _service.getToday();

      if (!mounted) return;

      setState(() {
        _reminders = reminders;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _loading = false;
      });
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

  String _dosage(
    Map<String, dynamic> reminder,
  ) {
    final medication =
        reminder['medication'];

    if (medication is Map) {
      return medication['dosage']?.toString() ??
          '';
    }

    return '';
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

  Future<void> _markStatus(
    String id,
    String status,
  ) async {
    try {
      await _service.updateStatus(
        id,
        status,
      );

      await _loadToday();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'TAKEN':
        return AppColors.success;
      case 'MISSED':
        return AppColors.error;
      case 'SKIPPED':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            onPressed: _loadToday,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadToday,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_reminders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadToday,
        child: ListView(
          children: const [
            SizedBox(height: 180),
            Icon(
              Icons.calendar_today,
              size: 60,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No medication scheduled today.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadToday,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder =
              _reminders[index];

          final status =
              reminder['status']
                      ?.toString()
                      .toUpperCase() ??
                  'PENDING';

          final time =
              _formatTime(
            reminder['scheduledAt']
                ?.toString(),
          );

          return Card(
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor:
                    _statusColor(status)
                        .withValues(alpha: 0.12),
                child: Icon(
                  status == 'TAKEN'
                      ? Icons.check
                      : Icons.medication,
                  color:
                      _statusColor(status),
                ),
              ),
              title: Text(
                _medicationName(reminder),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                [
                  if (time.isNotEmpty) time,
                  if (_dosage(reminder).isNotEmpty)
                    _dosage(reminder),
                  status,
                ].join(' • '),
              ),
              trailing:
                  status == 'PENDING'
                      ? PopupMenuButton<String>(
                          onSelected: (value) {
                            _markStatus(
                              reminder['id']
                                  .toString(),
                              value,
                            );
                          },
                          itemBuilder:
                              (context) => const [
                            PopupMenuItem(
                              value: 'TAKEN',
                              child:
                                  Text('Taken'),
                            ),
                            PopupMenuItem(
                              value: 'SKIPPED',
                              child:
                                  Text('Skip'),
                            ),
                            PopupMenuItem(
                              value: 'DELAYED',
                              child:
                                  Text('Delay'),
                            ),
                          ],
                        )
                      : null,
            ),
          );
        },
      ),
    );
  }
}