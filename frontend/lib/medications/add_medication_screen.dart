import 'package:flutter/material.dart';

import '../core/localization/app_strings.dart';
import '../models/medication.dart';
import '../services/medication_service.dart';
import '../services/schedule_service.dart';

class AddMedicationScreen extends StatefulWidget {
  final Medication? medication;

  const AddMedicationScreen({
    super.key,
    this.medication,
  });

  bool get isEditing => medication != null;

  @override
  State<AddMedicationScreen> createState() =>
      _AddMedicationScreenState();
}

class _AddMedicationScreenState
    extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();

  final MedicationService _medicationService =
      MedicationService();

  final ScheduleService _scheduleService =
      ScheduleService();

  String _type = 'Tablet';
  String _frequency = 'Daily';

  TimeOfDay _selectedTime = const TimeOfDay(
    hour: 8,
    minute: 0,
  );

  DateTime _startDate = DateTime.now();
  DateTime? _endDate;

  bool _loading = false;
  bool _loadingSchedule = false;

  String? _scheduleId;

  final List<String> _types = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Other',
  ];

  final List<String> _frequencies = [
    'Daily',
    'Weekly',
    'Monthly',
    'One-time',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.medication != null) {
      _loadExistingMedication();
    }
  }

  Future<void> _loadExistingMedication() async {
    final medication = widget.medication!;

    _nameController.text = medication.name;
    _dosageController.text = medication.dosage ?? '';
    _notesController.text = medication.notes ?? '';

    if (medication.type != null &&
        _types.contains(medication.type)) {
      _type = medication.type!;
    }

    setState(() {
      _loadingSchedule = true;
    });

    try {
      final schedules =
          await _scheduleService.getSchedules(
        medicationId: medication.id,
      );

      if (schedules.isNotEmpty) {
        final schedule = schedules.first;

        // Get schedule ID
        final id = schedule['id'];

        if (id != null) {
          _scheduleId = id.toString();
        }

        // Get frequency
        final scheduleType =
            schedule['scheduleType']?.toString();

        switch (scheduleType) {
          case 'WEEKLY':
            _frequency = 'Weekly';
            break;

          case 'MONTHLY':
            _frequency = 'Monthly';
            break;

          case 'ONE_TIME':
            _frequency = 'One-time';
            break;

          case 'DAILY':
          default:
            _frequency = 'Daily';
            break;
        }

        // Get start date
        final startDate =
            schedule['startDate']?.toString();

        if (startDate != null &&
            startDate.isNotEmpty) {
          final parsedDate =
              DateTime.tryParse(startDate);

          if (parsedDate != null) {
            _startDate = parsedDate;
          }
        }

        // Get end date
        final endDate =
            schedule['endDate']?.toString();

        if (endDate != null &&
            endDate.isNotEmpty) {
          final parsedEndDate =
              DateTime.tryParse(endDate);

          if (parsedEndDate != null) {
            _endDate = parsedEndDate;
          }
        }

        // Get time
        final timeOfDay =
            schedule['timeOfDay']?.toString();

        if (timeOfDay != null &&
            timeOfDay.contains(':')) {
          final parts = timeOfDay.split(':');

          if (parts.length >= 2) {
            final hour = int.tryParse(parts[0]);
            final minute = int.tryParse(parts[1]);

            if (hour != null &&
                minute != null &&
                hour >= 0 &&
                hour <= 23 &&
                minute >= 0 &&
                minute <= 59) {
              _selectedTime = TimeOfDay(
                hour: hour,
                minute: minute,
              );
            }
          }
        }
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not load medication schedule: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loadingSchedule = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  String _scheduleType() {
    switch (_frequency) {
      case 'Weekly':
        return 'WEEKLY';

      case 'Monthly':
        return 'MONTHLY';

      case 'One-time':
        return 'ONE_TIME';

      case 'Daily':
      default:
        return 'DAILY';
    }
  }

  String _formatTimeForBackend(
    TimeOfDay time,
  ) {
    final hour =
        time.hour.toString().padLeft(2, '0');

    final minute =
        time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String _formatDate(DateTime date) {
    final year =
        date.year.toString().padLeft(4, '0');

    final month =
        date.month.toString().padLeft(2, '0');

    final day =
        date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _selectedTime = selected;
    });
  }

  Future<void> _pickStartDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(
        const Duration(days: 3650),
      ),
      lastDate: DateTime(2100),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _startDate = selected;

      if (_endDate != null &&
          _endDate!.isBefore(selected)) {
        _endDate = null;
      }
    });
  }

  Future<void> _pickEndDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _endDate = selected;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      late Medication medication;

      // ==================================================
      // ADD NEW MEDICATION
      // ==================================================

      if (!widget.isEditing) {
        medication =
            await _medicationService.createMedication(
          name: _nameController.text,
          dosage: _dosageController.text,
          type: _type,
          notes: _notesController.text,
        );

        await _scheduleService.createSchedule(
          medicationId: medication.id,
          scheduleType: _scheduleType(),
          startDate:
              _startDate.toIso8601String(),
          endDate:
              _endDate?.toIso8601String(),
          timeOfDay:
              _formatTimeForBackend(
            _selectedTime,
          ),
        );
      }

      // ==================================================
      // EDIT EXISTING MEDICATION
      // ==================================================

      else {
        medication =
            await _medicationService.updateMedication(
          widget.medication!.id,
          name: _nameController.text,
          dosage: _dosageController.text,
          type: _type,
          notes: _notesController.text,
        );

        // Update existing schedule
        if (_scheduleId != null) {
          await _scheduleService.updateSchedule(
            _scheduleId!,
            scheduleType: _scheduleType(),
            startDate:
                _startDate.toIso8601String(),
            endDate:
                _endDate?.toIso8601String(),
            clearEndDate: _endDate == null,
            timeOfDay:
                _formatTimeForBackend(
              _selectedTime,
            ),
          );
        }

        // If somehow there is no schedule,
        // create one.
        else {
          await _scheduleService.createSchedule(
            medicationId: medication.id,
            scheduleType: _scheduleType(),
            startDate:
                _startDate.toIso8601String(),
            endDate:
                _endDate?.toIso8601String(),
            timeOfDay:
                _formatTimeForBackend(
              _selectedTime,
            ),
          );
        }
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Medication updated successfully'
                : 'Medication and schedule added successfully',
          ),
        ),
      );

      Navigator.pop(
        context,
        medication,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.isEditing;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Edit Medication'
              : AppStrings.get(
                  context,
                  'addMedication',
                ),
        ),
      ),

      body: _loadingSchedule
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // ============================
                  // MEDICATION NAME
                  // ============================

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(
                        context,
                        'medicationName',
                      ),
                      prefixIcon: const Icon(
                        Icons.medication,
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter medication name';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ============================
                  // DOSAGE
                  // ============================

                  TextFormField(
                    controller: _dosageController,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(
                        context,
                        'dosage',
                      ),
                      hintText: 'e.g. 500 mg',
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ============================
                  // TYPE
                  // ============================

                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(
                        context,
                        'type',
                      ),
                    ),
                    items: _types.map(
                      (type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      },
                    ).toList(),
                    onChanged: _loading
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() {
                                _type = value;
                              });
                            }
                          },
                  ),

                  const SizedBox(height: 16),

                  // ============================
                  // FREQUENCY
                  // ============================

                  DropdownButtonFormField<String>(
                    initialValue: _frequency,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(
                        context,
                        'frequency',
                      ),
                    ),
                    items: _frequencies.map(
                      (frequency) {
                        return DropdownMenuItem<String>(
                          value: frequency,
                          child: Text(frequency),
                        );
                      },
                    ).toList(),
                    onChanged: _loading
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() {
                                _frequency = value;
                              });
                            }
                          },
                  ),

                  const SizedBox(height: 16),

                  // ============================
                  // TIME
                  // ============================

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.access_time,
                      ),
                      title: Text(
                        AppStrings.get(
                          context,
                          'medicationTime',
                        ),
                      ),
                      subtitle: Text(
                        _selectedTime.format(context),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: _loading
                          ? null
                          : _pickTime,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ============================
                  // START DATE
                  // ============================

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.calendar_today,
                      ),
                      title: Text(
                        AppStrings.get(
                          context,
                          'startDate',
                        ),
                      ),
                      subtitle: Text(
                        _formatDate(_startDate),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                      onTap: _loading
                          ? null
                          : _pickStartDate,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ============================
                  // END DATE
                  // ============================

                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.event,
                      ),
                      title: Text(
                        AppStrings.get(
                          context,
                          'endDate',
                        ),
                      ),
                      subtitle: Text(
                        _endDate == null
                            ? 'No end date'
                            : _formatDate(_endDate!),
                      ),
                      trailing: _endDate == null
                          ? const Icon(
                              Icons.chevron_right,
                            )
                          : IconButton(
                              icon: const Icon(
                                Icons.clear,
                              ),
                              onPressed: _loading
                                  ? null
                                  : () {
                                      setState(() {
                                        _endDate = null;
                                      });
                                    },
                            ),
                      onTap: _loading
                          ? null
                          : _pickEndDate,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ============================
                  // NOTES
                  // ============================

                  TextFormField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: AppStrings.get(
                        context,
                        'notes',
                      ),
                      hintText: AppStrings.get(
                        context,
                        'additionalInstructions',
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ============================
                  // SAVE BUTTON
                  // ============================

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          _loading ? null : _save,
                      child: _loading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              isEditing
                                  ? 'Save Changes'
                                  : AppStrings.get(
                                      context,
                                      'saveMedication',
                                    ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}