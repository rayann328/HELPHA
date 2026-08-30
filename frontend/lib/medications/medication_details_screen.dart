import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/app_data.dart';
import '../../models/medication.dart';

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
  void _delete() {
    AppData.medications.remove(widget.medication);
    Navigator.pop(context);
  }

  void _markTaken() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medication marked as taken.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medication = widget.medication;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete Medication?'),
                  content: const Text(
                    'This medication will be removed from your list.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _delete();
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medication_rounded,
                size: 55,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              medication.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '${medication.dosage} • ${medication.type}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            _InfoTile(
              icon: Icons.repeat,
              title: 'Frequency',
              value: medication.frequency,
            ),

            _InfoTile(
              icon: Icons.access_time,
              title: 'Time',
              value: medication.times.join(', '),
            ),

            _InfoTile(
              icon: Icons.calendar_today,
              title: 'Start Date',
              value:
                  '${medication.startDate.day}/${medication.startDate.month}/${medication.startDate.year}',
            ),

            _InfoTile(
              icon: Icons.notes,
              title: 'Notes',
              value: medication.notes.isEmpty
                  ? 'No notes'
                  : medication.notes,
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: _markTaken,
              child: const Text(
                'Mark as Taken',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}