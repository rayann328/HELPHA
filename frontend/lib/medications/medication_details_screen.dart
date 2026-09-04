import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../models/medication.dart';
import '../services/medication_service.dart';
import '../services/reminder_service.dart';

class MedicationDetailsScreen extends StatefulWidget {
  final Medication medication;

  const MedicationDetailsScreen({
    super.key,
    required this.medication,
  });

  @override
  State<MedicationDetailsScreen> createState() =>
      _MedicationDetailsScreenState();
}

class _MedicationDetailsScreenState
    extends State<MedicationDetailsScreen> {
  final MedicationService _medicationService =
      MedicationService();

  final ReminderService _reminderService =
      ReminderService();

  bool _loading = false;

  Future<void> _delete() async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Delete medication?'),
          content: const Text(
            'This will permanently remove this medication.',
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await _medicationService.deleteMedication(
        widget.medication.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Medication deleted'),
        ),
      );

      Navigator.pop(context);
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

  Future<void> _archive() async {
    setState(() {
      _loading = true;
    });

    try {
      await _medicationService.archiveMedication(
        widget.medication.id,
      );

      if (!mounted) return;

      Navigator.pop(context);
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

  Future<void> _markTaken() async {
    setState(() {
      _loading = true;
    });

    try {
      final reminders =
          await _reminderService.getToday();

      final medicationReminders =
          reminders.where((reminder) {
        final medication =
            reminder['medication'];

        if (medication is! Map) {
          return false;
        }

        return medication['id']?.toString() ==
            widget.medication.id;
      }).toList();

      if (medicationReminders.isEmpty) {
        if (!mounted) return;

        setState(() {
          _loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No reminder found for this medication today.',
            ),
          ),
        );

        return;
      }

      await _reminderService.updateStatus(
        medicationReminders.first['id'].toString(),
        'TAKEN',
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Medication marked as taken',
          ),
        ),
      );
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

  Widget _infoRow(
    String title,
    String value,
    IconData icon,
  ) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medication = widget.medication;

    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'archive') {
                _archive();
              } else if (value == 'delete') {
                _delete();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'archive',
                child: Text('Archive'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor:
                AppColors.primary.withValues(
              alpha: 0.12,
            ),
            child: const Icon(
              Icons.medication,
              size: 44,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),

          Center(
            child: Text(
              medication.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 24),

          _infoRow(
            'Dosage',
            medication.dosage ?? '',
            Icons.medication,
          ),

          _infoRow(
            'Type',
            medication.type ?? '',
            Icons.category,
          ),

          _infoRow(
            'Strength',
            medication.strength ?? '',
            Icons.science,
          ),

          _infoRow(
            'Generic name',
            medication.genericName ?? '',
            Icons.info_outline,
          ),

          _infoRow(
            'Brand name',
            medication.brandName ?? '',
            Icons.business,
          ),

          _infoRow(
            'Notes',
            medication.notes ?? '',
            Icons.notes,
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed:
                  _loading ? null : _markTaken,
              icon: const Icon(
                Icons.check_circle,
              ),
              label: const Text(
                'Mark Today as Taken',
              ),
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed:
                _loading ? null : _delete,
            child: const Text(
              'Delete Medication',
            ),
          ),
        ],
      ),
    );
  }
}