import 'api_service.dart';

class HistoryService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>>
      getHistory() async {
    final response =
        await _api.get('/history');

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

  Future<Map<String, dynamic>> getHistoryItem(
    String id,
  ) async {
    final response =
        await _api.get('/history/$id');

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> createHistory({
    required String medicationId,
    String? scheduleId,
    required String scheduledAt,
    String status = 'PENDING',
    String? takenAt,
    String? note,
  }) async {
    final body = <String, dynamic>{
      'medicationId': medicationId,
      'scheduledAt': scheduledAt,
      'status': status,
    };

    if (scheduleId != null) {
      body['scheduleId'] = scheduleId;
    }

    if (takenAt != null) {
      body['takenAt'] = takenAt;
    }

    if (note != null) {
      body['note'] = note;
    }

    final response = await _api.post(
      '/history',
      body: body,
    );

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> updateHistory(
    String id, {
    String? status,
    String? takenAt,
    String? note,
  }) async {
    final body = <String, dynamic>{};

    if (status != null) {
      body['status'] = status;
    }

    if (takenAt != null) {
      body['takenAt'] = takenAt;
    }

    if (note != null) {
      body['note'] = note;
    }

    final response = await _api.patch(
      '/history/$id',
      body: body,
    );

    return Map<String, dynamic>.from(response);
  }

  Future<void> deleteHistory(
    String id,
  ) async {
    await _api.delete('/history/$id');
  }
}