import 'package:flutter/material.dart';

import '../../data/app_data.dart';
import '../../models/medication.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

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

  String _type = 'Tablet';
  String _frequency = 'Daily';
  TimeOfDay _selectedTime = const TimeOfDay(
    hour: 8,
    minute: 0,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final medication = Medication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
      type: _type,
      frequency: _frequency,
      times: [
        _selectedTime.format(context),
      ],
      notes: _notesController.text.trim(),
      startDate: DateTime.now(),
    );

    AppData.medications.add(medication);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Medication Name'),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Vitamin D',
                  prefixIcon: Icon(Icons.medication),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter medication name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _label('Dosage'),

              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  hintText: 'e.g. 500 mg',
                  prefixIcon: Icon(Icons.scale_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter dosage';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              _label('Type'),

              DropdownButtonFormField<String>(
                initialValue: _type,
                items: const [
                  DropdownMenuItem(
                    value: 'Tablet',
                    child: Text('Tablet'),
                  ),
                  DropdownMenuItem(
                    value: 'Capsule',
                    child: Text('Capsule'),
                  ),
                  DropdownMenuItem(
                    value: 'Syrup',
                    child: Text('Syrup'),
                  ),
                  DropdownMenuItem(
                    value: 'Injection',
                    child: Text('Injection'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _type = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              _label('Frequency'),

              DropdownButtonFormField<String>(
                initialValue: _frequency,
                items: const [
                  DropdownMenuItem(
                    value: 'Daily',
                    child: Text('Daily'),
                  ),
                  DropdownMenuItem(
                    value: 'Weekly',
                    child: Text('Weekly'),
                  ),
                  DropdownMenuItem(
                    value: 'Monthly',
                    child: Text('Monthly'),
                  ),
                  DropdownMenuItem(
                    value: 'One-time',
                    child: Text('One-time'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _frequency = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              _label('Time'),

              InkWell(
                onTap: _selectTime,
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    _selectedTime.format(context),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _label('Notes'),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Optional notes',
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _save,
                child: const Text(
                  'Save Medication',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}