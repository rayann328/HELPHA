import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/app_data.dart';
import '../../widgets/medication_card.dart';
import 'add_medication_screen.dart';
import 'medication_details_screen.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  @override
  Widget build(BuildContext context) {
    final medications = AppData.medications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medications'),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMedicationScreen(),
            ),
          );

          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Medication'),
      ),

      body: medications.isEmpty
          ? const Center(
              child: Text('No medications added yet.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];

                return MedicationCard(
                  medication: medication,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MedicationDetailsScreen(
                          medication: medication,
                        ),
                      ),
                    );

                    setState(() {});
                  },
                );
              },
            ),
    );
  }
}