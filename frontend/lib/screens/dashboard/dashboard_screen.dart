import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/localization/app_strings.dart';
import '../../models/medication.dart';
import '../../services/reminder_service.dart';
import '../../widgets/medication_card.dart';
import '../../medications/medications_screen.dart';
import '../../schedule/schedule_screen.dart';
import '../../calendar/calendar_screen.dart';
import '../../history/history_screen.dart';
import '../../profile/profile_screen.dart';
import '../../reminders/reminders_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _HomeContent(),
      MedicationsScreen(),
      ScheduleScreen(),
      RemindersScreen(),
      CalendarScreen(),
      HistoryScreen(),
      ProfileScreen(),
    ];
  }

Future<void> _selectPage(int index) async {
  setState(() {
    _selectedIndex = index;

    switch (index) {
      case 0:
        _pages[0] = _HomeContent(key: UniqueKey());
        break;

      case 1:
        _pages[1] = MedicationsScreen(key: UniqueKey());
        break;

      case 2:
        _pages[2] = ScheduleScreen(key: UniqueKey());
        break;

      case 3:
        _pages[3] = RemindersScreen(key: UniqueKey());
        break;

      case 4:
        _pages[4] = CalendarScreen(key: UniqueKey());
        break;

      case 5:
        _pages[5] = HistoryScreen(key: UniqueKey());
        break;

      case 6:
        _pages[6] = ProfileScreen(key: UniqueKey());
        break;
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectPage,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: AppStrings.get(context, 'home')),
          BottomNavigationBarItem(icon: const Icon(Icons.medication_outlined), activeIcon: const Icon(Icons.medication), label: AppStrings.get(context, 'medications')),
          BottomNavigationBarItem(icon: const Icon(Icons.schedule_outlined), activeIcon: const Icon(Icons.schedule), label: AppStrings.get(context, 'schedule')),
          BottomNavigationBarItem(icon: const Icon(Icons.notifications_none), activeIcon: const Icon(Icons.notifications), label: AppStrings.get(context, 'reminders')),
          BottomNavigationBarItem(icon: const Icon(Icons.calendar_month_outlined), activeIcon: const Icon(Icons.calendar_month), label: AppStrings.get(context, 'calendar')),
          BottomNavigationBarItem(icon: const Icon(Icons.history), label: AppStrings.get(context, 'history')),
          BottomNavigationBarItem(icon: const Icon(Icons.person_outline), activeIcon: const Icon(Icons.person), label: AppStrings.get(context, 'profile')),
        ],
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent({super.key});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final ReminderService _reminderService = ReminderService();
  List<Medication> _todayMedications = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTodayMedications();
  }

  Future<void> _loadTodayMedications() async {
    setState(() { _loading = true; _error = null; });
    try {
      final reminders = await _reminderService.getToday();
      final medicationMap = <String, Medication>{};
      for (final reminder in reminders) {
        final status = reminder['status']?.toString().toUpperCase() ?? 'PENDING';
        if (status != 'PENDING') continue;
        final medicationData = reminder['medication'];
        if (medicationData is! Map) continue;
        final medicationJson = Map<String, dynamic>.from(medicationData);
        final medicationId = medicationJson['id']?.toString() ?? reminder['medicationId']?.toString() ?? '';
        if (medicationId.isEmpty) continue;
        final medication = Medication.fromJson(medicationJson);
        final scheduledAt = reminder['scheduledAt']?.toString();
        if (scheduledAt != null && scheduledAt.isNotEmpty) {
          try {
            final date = DateTime.parse(scheduledAt).toLocal();
            final time = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
            if (medication.times.isEmpty) {
              medicationMap[medicationId] = Medication(
                id: medication.id, name: medication.name, genericName: medication.genericName,
                brandName: medication.brandName, dosage: medication.dosage, strength: medication.strength,
                type: medication.type, color: medication.color, shape: medication.shape, notes: medication.notes,
                photoUrl: medication.photoUrl, frequency: medication.frequency, times: [time],
                startDate: medication.startDate, endDate: medication.endDate, status: medication.status,
              );
            } else {
              medicationMap[medicationId] = medication;
            }
          } catch (_) { medicationMap[medicationId] = medication; }
        } else {
          medicationMap[medicationId] = medication;
        }
      }
      if (!mounted) return;
      setState(() { _todayMedications = medicationMap.values.toList(); _loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HELPHA', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
              _loadTodayMedications();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTodayMedications,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.get(context, 'goodMorning'), style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(AppStrings.get(context, 'stayOnTrack'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: _StatCard(title: AppStrings.get(context, 'adherence'), value: '92%', icon: Icons.trending_up)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(title: AppStrings.get(context, 'streak'), value: '7 ${AppStrings.get(context, 'days')}', icon: Icons.local_fire_department)),
              ]),
              const SizedBox(height: 28),
              Text(AppStrings.get(context, 'todaysMedications'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTodayMedications(),
              const SizedBox(height: 20),
              Text(AppStrings.get(context, 'quickActions'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _ActionButton(icon: Icons.medication, title: AppStrings.get(context, 'medications'), onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => MedicationsScreen())); _loadTodayMedications(); })),
                const SizedBox(width: 12),
                Expanded(child: _ActionButton(icon: Icons.schedule, title: AppStrings.get(context, 'schedule'), onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => ScheduleScreen())); _loadTodayMedications(); })),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _ActionButton(icon: Icons.notifications_none, title: AppStrings.get(context, 'reminders'), onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => RemindersScreen())); _loadTodayMedications(); })),
                const SizedBox(width: 12),
                Expanded(child: _ActionButton(icon: Icons.calendar_month, title: AppStrings.get(context, 'calendar'), onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => CalendarScreen())); _loadTodayMedications(); })),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _ActionButton(icon: Icons.history, title: AppStrings.get(context, 'history'), onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreen())); _loadTodayMedications(); })),
                const Expanded(child: SizedBox()),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayMedications() {
    if (_loading) return const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator()));
    if (_error != null) {
      return Center(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        const Icon(Icons.error_outline, size: 40), const SizedBox(height: 10), Text(_error!, textAlign: TextAlign.center), const SizedBox(height: 12),
        ElevatedButton(onPressed: _loadTodayMedications, child: Text(AppStrings.get(context, 'retry'))),
      ])));
    }
    if (_todayMedications.isEmpty) {
      return Center(child: Padding(padding: const EdgeInsets.all(30), child: Text(AppStrings.get(context, 'noMedicationToday'), style: const TextStyle(fontSize: 16))));
    }
    return Column(children: _todayMedications.map((medication) => MedicationCard(medication: medication)).toList());
  }
}

class _StatCard extends StatelessWidget {
  final String title; final String value; final IconData icon;
  const _StatCard({required this.title, required this.value, required this.icon});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: colorScheme.primary), const SizedBox(height: 12),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
        Text(title, style: TextStyle(color: colorScheme.onSurfaceVariant)),
      ]),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: colorScheme.outline.withValues(alpha: 0.35))),
        child: Column(children: [Icon(icon, size: 30, color: colorScheme.primary), const SizedBox(height: 8), Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface))]),
      ),
    );
  }
}
