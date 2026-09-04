import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState
    extends State<HistoryScreen> {
  final HistoryService _service =
      HistoryService();

  List<Map<String, dynamic>> _history = [];
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
      final data =
          await _service.getHistory();

      if (!mounted) return;

      setState(() {
        _history = data.reversed.toList();
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

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'TAKEN':
        return AppColors.success;
      case 'MISSED':
        return AppColors.error;
      case 'SKIPPED':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            onPressed: _loadHistory,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadHistory,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_history.isEmpty) {
      return const Center(
        child: Text(
          'No medication history yet.',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];

          final status =
              item['status']?.toString() ??
                  'PENDING';

          final medication =
              item['medication'];

          String medicationName =
              'Medication';

          if (medication is Map) {
            medicationName =
                medication['name']?.toString() ??
                    'Medication';
          }

          final scheduledAt =
              item['scheduledAt']
                      ?.toString() ??
                  '';

          return Card(
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    _statusColor(status)
                        .withValues(alpha: 0.12),
                child: Icon(
                  status == 'TAKEN'
                      ? Icons.check
                      : status == 'MISSED'
                          ? Icons.close
                          : Icons.history,
                  color: _statusColor(status),
                ),
              ),
              title: Text(
                medicationName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                scheduledAt.isEmpty
                    ? status
                    : '$scheduledAt\n$status',
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