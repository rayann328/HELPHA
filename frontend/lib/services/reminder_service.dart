import 'api_service.dart';

class ReminderService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>>
      getUpcoming({
    int limit = 20,
  }) async {
    final response = await _api.get(
      '/reminders/upcoming?limit=$limit',
    );

    if (response is! List) {
      return [];
    }

    return response
        .map(
          (item) =>
              Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>>
      getToday() async {
    final response =
        await _api.get('/reminders/today');

    if (response is! List) {
      return [];
    }

    return response
        .map(
          (item) =>
              Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<List<Map<String, dynamic>>>
      getRange(
    DateTime from,
    DateTime to,
  ) async {
    final fromValue =
        Uri.encodeComponent(
      from.toUtc().toIso8601String(),
    );

    final toValue =
        Uri.encodeComponent(
      to.toUtc().toIso8601String(),
    );

    final response = await _api.get(
      '/reminders/range?from=$fromValue&to=$toValue',
    );

    if (response is! List) {
      return [];
    }

    return response
        .map(
          (item) =>
              Map<String, dynamic>.from(item),
        )
        .toList();
  }

  Future<Map<String, dynamic>> getReminder(
    String id,
  ) async {
    final response =
        await _api.get('/reminders/$id');

    return Map<String, dynamic>.from(response);
  }

Future<Map<String, dynamic>> updateStatus(
  String id,
  String status, {
  String? note,
}) async {
  var endpoint =
      '/reminders/$id/status?status=${Uri.encodeComponent(status.toUpperCase())}';

  if (note != null && note.isNotEmpty) {
    endpoint +=
        '&note=${Uri.encodeComponent(note)}';
  }

  final response = await _api.patch(endpoint);

  return Map<String, dynamic>.from(response);
}
}