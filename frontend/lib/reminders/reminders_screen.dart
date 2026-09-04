import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/reminder_service.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() =>
      _RemindersScreenState();
}

class _RemindersScreenState
    extends State<RemindersScreen> {
  final ReminderService _service =
      ReminderService();

  List<Map<String, dynamic>> _reminders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
final allReminders =
    await _service.getUpcoming(limit: 20);

// Keep only the nearest upcoming reminder
// for each medication.
final uniqueReminders =
    <String, Map<String, dynamic>>{};

for (final reminder in allReminders) {
  final medication =
      reminder['medication'];

  String medicationId = '';

  if (medication is Map) {
    medicationId =
        medication['id']?.toString() ?? '';
  }

  // Fallback to DoseLog medicationId.
  if (medicationId.isEmpty) {
    medicationId =
        reminder['medicationId']?.toString() ??
            '';
  }

  if (medicationId.isEmpty) {
    medicationId =
        reminder['id']?.toString() ?? '';
  }

  // Since the backend returns upcoming reminders
  // already sorted, the first one is the nearest.
  if (!uniqueReminders.containsKey(
    medicationId,
  )) {
    uniqueReminders[medicationId] =
        reminder;
  }
}

final reminders =
    uniqueReminders.values.toList();

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
      final dosage =
          medication['dosage']?.toString() ?? '';

      final strength =
          medication['strength']?.toString() ?? '';

      if (dosage.isNotEmpty &&
          strength.isNotEmpty) {
        return '$dosage • $strength';
      }

      if (dosage.isNotEmpty) {
        return dosage;
      }

      if (strength.isNotEmpty) {
        return strength;
      }
    }

    return '';
  }

  String _formatDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }

    try {
      final date =
          DateTime.parse(value).toLocal();

      final hour = date.hour == 0
          ? 12
          : date.hour > 12
              ? date.hour - 12
              : date.hour;

      final minute =
          date.minute.toString().padLeft(2, '0');

      final period =
          date.hour >= 12 ? 'PM' : 'AM';

      return '${date.day}/${date.month}/${date.year} '
          'at $hour:$minute $period';
    } catch (_) {
      return value;
    }
  }

  Future<void> _updateStatus(
    String id,
    String status,
  ) async {
    try {
      await _service.updateStatus(
        id,
        status,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'TAKEN'
                ? 'Medication marked as taken.'
                : 'Medication marked as $status.',
          ),
        ),
      );

      await _loadReminders();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not update reminder: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            onPressed: _loadReminders,
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 50,
              ),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadReminders,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_reminders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadReminders,
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Icon(
              Icons.notifications_none,
              size: 70,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No upcoming reminders.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'You are all caught up!',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReminders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder =
              _reminders[index];

          final id =
              reminder['id']?.toString() ?? '';

          final status =
              reminder['status']
                      ?.toString()
                      .toUpperCase() ??
                  'PENDING';

          final scheduledAt =
              reminder['scheduledAt']
                  ?.toString();

          final dosage =
              _dosage(reminder);

          return Card(
            margin: const EdgeInsets.only(
              bottom: 14,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
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
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              _medicationName(
                                reminder,
                              ),
                              style:
                                  const TextStyle(
                                fontSize: 17,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            if (dosage.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets
                                        .only(
                                  top: 4,
                                ),
                                child: Text(
                                  dosage,
                                  style:
                                      const TextStyle(
                                    color: AppColors
                                        .textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      _StatusBadge(
                        status: status,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 20,
                        color:
                            AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatDateTime(
                            scheduledAt,
                          ),
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  if (status == 'PENDING')
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: id.isEmpty
                                ? null
                                : () =>
                                    _updateStatus(
                                      id,
                                      'TAKEN',
                                    ),
                            icon: const Icon(
                              Icons.check,
                            ),
                            label: const Text(
                              'Taken',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: id.isEmpty
                                ? null
                                : () =>
                                    _updateStatus(
                                      id,
                                      'SKIPPED',
                                    ),
                            icon: const Icon(
                              Icons.close,
                            ),
                            label: const Text(
                              'Skip',
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  Color _color() {
    switch (status) {
      case 'TAKEN':
        return AppColors.success;
      case 'SKIPPED':
        return AppColors.warning;
      case 'MISSED':
        return AppColors.error;
      case 'DELAYED':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}