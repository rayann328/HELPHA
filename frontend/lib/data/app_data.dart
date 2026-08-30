import '../models/medication.dart';

class AppData {
  static final List<Medication> medications = [
    Medication(
      id: '1',
      name: 'Vitamin D',
      dosage: '1000 IU',
      type: 'Tablet',
      frequency: 'Daily',
      times: ['08:00 AM'],
      notes: 'Take after breakfast',
      startDate: DateTime.now(),
    ),
    Medication(
      id: '2',
      name: 'Paracetamol',
      dosage: '500 mg',
      type: 'Tablet',
      frequency: 'Daily',
      times: ['02:00 PM', '08:00 PM'],
      notes: 'Take with water',
      startDate: DateTime.now(),
    ),
  ];

  static final List<Map<String, dynamic>> history = [
    {
      'name': 'Vitamin D',
      'dosage': '1000 IU',
      'time': '08:00 AM',
      'status': 'Taken',
      'date': 'Today',
    },
    {
      'name': 'Paracetamol',
      'dosage': '500 mg',
      'time': '02:00 PM',
      'status': 'Taken',
      'date': 'Yesterday',
    },
    {
      'name': 'Vitamin D',
      'dosage': '1000 IU',
      'time': '08:00 AM',
      'status': 'Missed',
      'date': 'Yesterday',
    },
  ];
}