import 'package:flutter/material.dart';
import '../core/localization/app_strings.dart';
import '../core/constants/app_colors.dart';
import '../services/history_service.dart';
import '../services/medication_service.dart';
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}
class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  final MedicationService _medicationService = MedicationService();
  List<Map<String, dynamic>> _history = [];
  Map<String, String> _medicationNames = {};
  bool _loading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }
 Future<void> _loadHistory() async {
  setState(() {
    _loading = true;
    _error = null;
  });

  try {
    final history = await _historyService.getHistory();
    final medications = await _medicationService.getMedications();

    final names = <String, String>{};

    for (final medication in medications) {
      names[medication.id] = medication.name;
    }

    // History should contain completed actions only.
    // IMPORTANT: Do NOT filter by date here.
    // A TAKEN/SKIPPED/MISSED/DELAYED record belongs in history
    // even if its scheduledAt value is unusual.
    final filtered = history.where((item) {
      final status = item['status']?.toString().toUpperCase() ?? '';

      return status == 'TAKEN' ||
          status == 'SKIPPED' ||
          status == 'DELAYED' ||
          status == 'MISSED';
    }).toList();

    filtered.sort((a, b) {
      final aDate = DateTime.tryParse(
        a['scheduledAt']?.toString() ?? '',
      );

      final bDate = DateTime.tryParse(
        b['scheduledAt']?.toString() ?? '',
      );

      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      return bDate.compareTo(aDate);
    });

    if (!mounted) return;

    setState(() {
      _history = filtered;
      _medicationNames = names;
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
    Map<String, dynamic> item,
  ) {
    // Firzst try nested medication from backend.
    final medication = item['medication'];
    if (medication is Map) {
      final name = medication['name']?.toString();
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }
    // Otherwise use medicationId.
    final medicationId =
        item['medicationId']?.toString() ?? '';
    final name =
        _medicationNames[medicationId];
    if (name != null && name.isNotEmpty) {
      return name;
    }
    return 'Medication';
  }
  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'TAKEN':
        return AppColors.success;
      case 'MISSED':
        return AppColors.error;
      case 'SKIPPED':
        return AppColors.warning;
      case 'DELAYED':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }
  IconData _statusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'TAKEN':
        return Icons.check;
      case 'MISSED':
        return Icons.close;
      case 'SKIPPED':
        return Icons.history;
      case 'DELAYED':
        return Icons.schedule;
      default:
        return Icons.history;
    }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get(context, 'history')),
        actions: [
          IconButton(
            onPressed: _loadHistory,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
  Widget _buildBody() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadHistory,
                child: Text(AppStrings.get(context, 'retry')),
              ),
            ],
          ),
        ),
      );
    }
    if (_history.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadHistory,
        child: ListView(
          physics:
              AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 180),
            Center(
              child: Text(AppStrings.get(context, 'noHistory'),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          final status =
              item['status']
                  ?.toString()
                  .toUpperCase() ??
                  'PENDING';
          final scheduledAt =
              item['scheduledAt']
                  ?.toString() ??
                  '';
          final color =
              _statusColor(status);
          return Card(
            margin:
                EdgeInsets.only(
              bottom: 12,
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor:
                    color.withValues(
                  alpha: 0.12,
                ),
                child: Icon(
                  _statusIcon(status),
                  color: color,
                ),
              ),
              title: Text(
                _medicationName(item),
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              subtitle: Text(
                scheduledAt.isEmpty
                    ? status
                    : '${_formatDateTime(scheduledAt)}\n${AppStrings.get(context, status.toLowerCase())}',
              ),
              isThreeLine:
                  scheduledAt.isNotEmpty,
            ),
          );
        },
      ),
    );
  }
}