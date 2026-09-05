import 'package:flutter/material.dart';
import '../core/localization/app_strings.dart';
import '../services/medication_service.dart';
import '../services/schedule_service.dart';
class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});
  @override
  State<AddMedicationScreen> createState() =>
      _AddMedicationScreenState();
}
class _AddMedicationScreenState
    extends State<AddMedicationScreen> {
  final _formKey =
      GlobalKey<FormState>();
  final _nameController =
      TextEditingController();
  final _dosageController =
      TextEditingController();
  final _notesController =
      TextEditingController();
  final MedicationService
      _medicationService =
      MedicationService();
  final ScheduleService
      _scheduleService =
      ScheduleService();
  String _type = 'Tablet';
  String _frequency = 'Daily';
  TimeOfDay _selectedTime =
      TimeOfDay(
    hour: 8,
    minute: 0,
  );
  DateTime _startDate =
      DateTime.now();
  DateTime? _endDate;
  bool _loading = false;
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
  String _formatDate(
    DateTime date,
  ) {
    final year =
        date.year.toString().padLeft(4, '0');
    final month =
        date.month.toString().padLeft(2, '0');
    final day =
        date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
  Future<void> _pickTime() async {
    final selected =
        await showTimePicker(
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
    final selected =
        await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now()
          .subtract(
        Duration(days: 3650),
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
    final selected =
        await showDatePicker(
      context: context,
      initialDate:
          _endDate ?? _startDate,
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
    if (!_formKey.currentState!
        .validate()) {
      return;
    }
    setState(() {
      _loading = true;
    });
    try {
      // STEP 1:
      // Create the medication.
      final medication =
          await _medicationService
              .createMedication(
        name: _nameController.text,
        dosage: _dosageController.text,
        type: _type,
        notes: _notesController.text,
      );
      // STEP 2:
      // Create the schedule for that medication.
      await _scheduleService
          .createSchedule(
        medicationId:
            medication.id,
        scheduleType:
            _scheduleType(),
        startDate:
            _startDate.toIso8601String(),
        endDate:
            _endDate?.toIso8601String(),
        timeOfDay:
            _formatTimeForBackend(
          _selectedTime,
        ),
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Medication and schedule added successfully',
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
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(context, 'addMedication'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:
              EdgeInsets.all(20),
          children: [
            TextFormField(
              controller:
                  _nameController,
              decoration:
                  InputDecoration(
                labelText: AppStrings.get(context, 'medicationName'),
                prefixIcon:
                    Icon(
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
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller:
                  _dosageController,
              decoration:
                  InputDecoration(
                labelText: AppStrings.get(context, 'dosage'),
                hintText:
                    'e.g. 500 mg',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            DropdownButtonFormField<
                String>(
              initialValue: _type,
              decoration:
                  InputDecoration(
                labelText: AppStrings.get(context, 'type'),
              ),
              items: _types
                  .map(
                    (type) =>
                        DropdownMenuItem<
                            String>(
                      value: type,
                      child:
                          Text(type),
                    ),
                  )
                  .toList(),
              onChanged:
                  _loading
                      ? null
                      : (value) {
                          if (value !=
                              null) {
                            setState(() {
                              _type =
                                  value;
                            });
                          }
                        },
            ),
            SizedBox(
              height: 16,
            ),
            // FREQUENCY
            DropdownButtonFormField<
                String>(
              initialValue:
                  _frequency,
              decoration:
                  InputDecoration(
                labelText: AppStrings.get(context, 'frequency'),
              ),
              items: _frequencies
                  .map(
                    (frequency) =>
                        DropdownMenuItem<
                            String>(
                      value:
                          frequency,
                      child:
                          Text(
                        frequency,
                      ),
                    ),
                  )
                  .toList(),
              onChanged:
                  _loading
                      ? null
                      : (value) {
                          if (value !=
                              null) {
                            setState(() {
                              _frequency =
                                  value;
                            });
                          }
                        },
            ),
            SizedBox(
              height: 16,
            ),
            // TIME
            Card(
              child: ListTile(
                leading:
                    Icon(
                  Icons.access_time,
                ),
                title:
                    Text(AppStrings.get(context, 'medicationTime'),
                ),
                subtitle:
                    Text(
                  _selectedTime
                      .format(
                    context,
                  ),
                ),
                trailing:
                    Icon(
                  Icons.chevron_right,
                ),
                onTap:
                    _loading
                        ? null
                        : _pickTime,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            // START DATE
            Card(
              child: ListTile(
                leading:
                    Icon(
                  Icons.calendar_today,
                ),
                title:
                    Text(AppStrings.get(context, 'startDate'),
                ),
                subtitle:
                    Text(
                  _formatDate(
                    _startDate,
                  ),
                ),
                trailing:
                    Icon(
                  Icons.chevron_right,
                ),
                onTap:
                    _loading
                        ? null
                        : _pickStartDate,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            // END DATE
            Card(
              child: ListTile(
                leading:
                    Icon(
                  Icons.event,
                ),
                title:
                    Text(AppStrings.get(context, 'endDate'),
                ),
                subtitle:
                    Text(
                  _endDate == null
                      ? 'No end date'
                      : _formatDate(
                          _endDate!,
                        ),
                ),
                trailing:
                    _endDate == null
                        ? Icon(
                            Icons
                                .chevron_right,
                          )
                        : IconButton(
                            icon:
                                Icon(
                              Icons.clear,
                            ),
                            onPressed:
                                _loading
                                    ? null
                                    : () {
                                        setState(
                                          () {
                                            _endDate =
                                                null;
                                          },
                                        );
                                      },
                          ),
                onTap:
                    _loading
                        ? null
                        : _pickEndDate,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller:
                  _notesController,
              maxLines: 4,
              decoration:
                  InputDecoration(
                labelText: AppStrings.get(context, 'notes'),
                hintText: AppStrings.get(context, 'additionalInstructions'),
              ),
            ),
            SizedBox(
              height: 28,
            ),
            SizedBox(
              height: 52,
              child:
                  ElevatedButton(
                onPressed:
                    _loading
                        ? null
                        : _save,
                child: _loading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child:
                            CircularProgressIndicator(
                          strokeWidth:
                              2,
                        ),
                      )
                    : Text(AppStrings.get(context, 'saveMedication'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}