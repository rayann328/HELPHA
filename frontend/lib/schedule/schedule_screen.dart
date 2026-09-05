import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/reminder_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ReminderService _service = ReminderService();

  List<Map<String, dynamic>> _reminders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  // ============================================================
  // LOAD TODAY'S SCHEDULE
  // ============================================================

  Future<void> _loadToday() async {
    if (mounted) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final reminders = await _service.getToday();

      // Sort by scheduled time.
      reminders.sort((a, b) {
        final aDate = DateTime.tryParse(
          a['scheduledAt']?.toString() ?? '',
        );

        final bDate = DateTime.tryParse(
          b['scheduledAt']?.toString() ?? '',
        );

        if (aDate == null && bDate == null) {
          return 0;
        }

        if (aDate == null) {
          return 1;
        }

        if (bDate == null) {
          return -1;
        }

        return aDate.compareTo(bDate);
      });

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

  // ============================================================
  // MEDICATION NAME
  // ============================================================

  String _medicationName(
    Map<String, dynamic> reminder,
  ) {
    final medication = reminder['medication'];

    if (medication is Map) {
      final name = medication['name']?.toString();

      if (name != null && name.trim().isNotEmpty) {
        return name;
      }
    }

    final directName =
        reminder['medicationName']?.toString();

    if (directName != null &&
        directName.trim().isNotEmpty) {
      return directName;
    }

    return 'Medication';
  }

  // ============================================================
  // DOSAGE
  // ============================================================

  String _dosage(
    Map<String, dynamic> reminder,
  ) {
    final medication = reminder['medication'];

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

    final directDosage =
        reminder['dosage']?.toString();

    return directDosage ?? '';
  }

  // ============================================================
  // TIMING TAG
  // ============================================================

  String _timingTag(
    Map<String, dynamic> reminder,
  ) {
    final schedule = reminder['schedule'];

    if (schedule is Map) {
      final tag =
          schedule['timingTag']?.toString();

      if (tag != null && tag.isNotEmpty) {
        return _prettyText(tag);
      }
    }

    final directTag =
        reminder['timingTag']?.toString();

    if (directTag != null &&
        directTag.isNotEmpty) {
      return _prettyText(directTag);
    }

    return '';
  }

  // ============================================================
  // FORMAT TEXT
  // ============================================================

  String _prettyText(String value) {
    return value
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(String? value) {
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
          date.minute
              .toString()
              .padLeft(2, '0');

      final period =
          date.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    } catch (_) {
      return value;
    }
  }

  // ============================================================
  // STATUS COLOR
  // ============================================================

  Color _statusColor(String status) {
    switch (status) {
      case 'TAKEN':
        return AppColors.success;

      case 'SKIPPED':
        return AppColors.warning;

      case 'MISSED':
        return AppColors.error;

      case 'DELAYED':
        return Colors.orange;

      default:
        return AppColors.primary;
    }
  }

  // ============================================================
  // STATUS ICON
  // ============================================================

  IconData _statusIcon(String status) {
    switch (status) {
      case 'TAKEN':
        return Icons.check_circle;

      case 'SKIPPED':
        return Icons.skip_next;

      case 'MISSED':
        return Icons.error_outline;

      case 'DELAYED':
        return Icons.schedule;

      default:
        return Icons.medication;
    }
  }

  // ============================================================
  // UPDATE STATUS
  // ============================================================

  Future<void> _markStatus(
    String id,
    String status,
  ) async {
    if (id.isEmpty) {
      _showMessage('Invalid reminder ID.');
      return;
    }

    try {
      await _service.updateStatus(
        id,
        status,
      );

      if (!mounted) return;

      _showMessage(
        status == 'TAKEN'
            ? 'Medication marked as taken.'
            : status == 'SKIPPED'
                ? 'Medication skipped.'
                : 'Medication marked as delayed.',
      );

      await _loadToday();
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Could not update medication: $e',
      );
    }
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final dayName =
        _dayName(now.weekday);

    final monthName =
        _monthName(now.month);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed:
                _loading ? null : _loadToday,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(
        dayName,
        monthName,
        now.day,
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody(
    String dayName,
    String monthName,
    int day,
  ) {
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
                size: 55,
                color: Colors.red,
              ),

              const SizedBox(height: 16),

              Text(
                _error!,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _loadToday,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadToday,
      child: ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          30,
        ),
        children: [
          // ----------------------------------------------------
          // DATE HEADER
          // ----------------------------------------------------

          _buildDateHeader(
            dayName,
            monthName,
            day,
          ),

          const SizedBox(height: 28),

          // ----------------------------------------------------
          // EMPTY STATE
          // ----------------------------------------------------

          if (_reminders.isEmpty)
            _buildEmptyState(),

          // ----------------------------------------------------
          // TIMELINE
          // ----------------------------------------------------

          if (_reminders.isNotEmpty)
            _buildTimeline(),
        ],
      ),
    );
  }

  // ============================================================
  // DATE HEADER
  // ============================================================

  Widget _buildDateHeader(
    String dayName,
    String monthName,
    int day,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(
          alpha: 0.08,
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                '$dayName, $monthName $day',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                '${_reminders.length} medication'
                '${_reminders.length == 1 ? '' : 's'} scheduled',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 75,
            color:
                AppColors.primary.withValues(
              alpha: 0.5,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'No medications today',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Your schedule is clear for today.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TIMELINE
  // ============================================================

  Widget _buildTimeline() {
    return Column(
      children: List.generate(
        _reminders.length,
        (index) {
          final reminder =
              _reminders[index];

          final isLast =
              index == _reminders.length - 1;

          return _buildTimelineItem(
            reminder,
            isLast,
          );
        },
      ),
    );
  }

  // ============================================================
  // TIMELINE ITEM
  // ============================================================

  Widget _buildTimelineItem(
    Map<String, dynamic> reminder,
    bool isLast,
  ) {
    final id =
        reminder['id']?.toString() ?? '';

    final status =
        reminder['status']
                ?.toString()
                .toUpperCase() ??
            'PENDING';

    final name =
        _medicationName(reminder);

    final dosage =
        _dosage(reminder);

    final timing =
        _timingTag(reminder);

    final time =
        _formatTime(
      reminder['scheduledAt']?.toString(),
    );

    final statusColor =
        _statusColor(status);

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // ------------------------------------------------------
        // LEFT TIME COLUMN
        // ------------------------------------------------------

        SizedBox(
          width: 72,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 3),
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),

        // ------------------------------------------------------
        // TIMELINE
        // ------------------------------------------------------

        SizedBox(
          width: 28,
          child: Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          statusColor.withValues(
                        alpha: 0.25,
                      ),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 145,
                  color:
                      AppColors.primary
                          .withValues(
                    alpha: 0.15,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // ------------------------------------------------------
        // MEDICATION CARD
        // ------------------------------------------------------

        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(
              bottom: 18,
            ),
            child: _buildMedicationCard(
              reminder: reminder,
              id: id,
              status: status,
              name: name,
              dosage: dosage,
              timing: timing,
              statusColor: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MEDICATION CARD
  // ============================================================

  Widget _buildMedicationCard({
    required Map<String, dynamic> reminder,
    required String id,
    required String status,
    required String name,
    required String dosage,
    required String timing,
    required Color statusColor,
  }) {
    final isPending =
        status == 'PENDING';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: status == 'TAKEN'
            ? AppColors.success.withValues(
                alpha: 0.05,
              )
            : Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: status == 'TAKEN'
              ? AppColors.success
                  .withValues(alpha: 0.2)
              : Colors.grey.withValues(
                  alpha: 0.15,
                ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ----------------------------------------------------
          // NAME + STATUS
          // ----------------------------------------------------

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              _StatusBadge(
                status: status,
              ),
            ],
          ),

          // ----------------------------------------------------
          // DOSAGE
          // ----------------------------------------------------

          if (dosage.isNotEmpty) ...[
            const SizedBox(height: 7),

            Row(
              children: [
                Icon(
                  Icons.medication_outlined,
                  size: 17,
                  color:
                      AppColors.textSecondary,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    dosage,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // ----------------------------------------------------
          // TIMING
          // ----------------------------------------------------

          if (timing.isNotEmpty) ...[
            const SizedBox(height: 6),

            Row(
              children: [
                Icon(
                  Icons.restaurant_outlined,
                  size: 17,
                  color:
                      AppColors.textSecondary,
                ),

                const SizedBox(width: 6),

                Text(
                  timing,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],

          // ----------------------------------------------------
          // ACTIONS
          // ----------------------------------------------------

          if (isPending) ...[
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child:
                      ElevatedButton.icon(
                    onPressed: id.isEmpty
                        ? null
                        : () => _markStatus(
                              id,
                              'TAKEN',
                            ),
                    icon: const Icon(
                      Icons.check,
                      size: 18,
                    ),
                    label:
                        const Text('Taken'),
                  ),
                ),

                const SizedBox(width: 8),

                SizedBox(
                  width: 48,
                  height: 42,
                  child:
                      OutlinedButton(
                    onPressed: id.isEmpty
                        ? null
                        : () => _markStatus(
                              id,
                              'SKIPPED',
                            ),
                    child: const Icon(
                      Icons.close,
                      size: 19,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // DAY NAME
  // ============================================================

  String _dayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[weekday - 1];
  }

  // ============================================================
  // MONTH NAME
  // ============================================================

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month - 1];
  }
}

// ================================================================
// STATUS BADGE
// ================================================================

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
        return Colors.orange;

      default:
        return AppColors.primary;
    }
  }

  IconData _icon() {
    switch (status) {
      case 'TAKEN':
        return Icons.check;

      case 'SKIPPED':
        return Icons.close;

      case 'MISSED':
        return Icons.warning_amber;

      case 'DELAYED':
        return Icons.schedule;

      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.10,
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            _icon(),
            size: 13,
            color: color,
          ),

          const SizedBox(width: 4),

          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}