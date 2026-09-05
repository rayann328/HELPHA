import 'api_service.dart';

class ScheduleService {
  final ApiService _api = ApiService();

  // ==================================================
  // GET ALL SCHEDULES
  // ==================================================

  Future<List<Map<String, dynamic>>> getSchedules({
    String? medicationId,
  }) async {
    String endpoint = '/schedules';

    if (medicationId != null &&
        medicationId.isNotEmpty) {
      endpoint +=
          '?medicationId=${Uri.encodeComponent(medicationId)}';
    }

    final response = await _api.get(endpoint);

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

  // ==================================================
  // GET ONE SCHEDULE
  // ==================================================

  Future<Map<String, dynamic>> getSchedule(
    String id,
  ) async {
    final response =
        await _api.get('/schedules/$id');

    return Map<String, dynamic>.from(response);
  }

  // ==================================================
  // CREATE SCHEDULE
  // ==================================================

  Future<Map<String, dynamic>> createSchedule({
    required String medicationId,
    required String scheduleType,
    required String startDate,
    String? endDate,
    int? intervalValue,
    String? intervalUnit,
    String? daysOfWeek,
    int? dayOfMonth,
    String? timeOfDay,
    String? timingTag,
  }) async {
    final body = <String, dynamic>{
      'medicationId': medicationId,
      'scheduleType': scheduleType,
      'startDate': startDate,
    };

    if (endDate != null &&
        endDate.isNotEmpty) {
      body['endDate'] = endDate;
    }

    if (intervalValue != null) {
      body['intervalValue'] = intervalValue;
    }

    if (intervalUnit != null &&
        intervalUnit.isNotEmpty) {
      body['intervalUnit'] = intervalUnit;
    }

    if (daysOfWeek != null &&
        daysOfWeek.isNotEmpty) {
      body['daysOfWeek'] = daysOfWeek;
    }

    if (dayOfMonth != null) {
      body['dayOfMonth'] = dayOfMonth;
    }

    if (timeOfDay != null &&
        timeOfDay.isNotEmpty) {
      body['timeOfDay'] = timeOfDay;
    }

    if (timingTag != null &&
        timingTag.isNotEmpty) {
      body['timingTag'] = timingTag;
    }

    final response = await _api.post(
      '/schedules',
      body: body,
    );

    return Map<String, dynamic>.from(
      response,
    );
  }

  // ==================================================
  // UPDATE SCHEDULE
  // ==================================================

  Future<Map<String, dynamic>> updateSchedule(
    String id, {
    String? scheduleType,
    String? startDate,
    String? endDate,
    bool clearEndDate = false,
    int? intervalValue,
    String? intervalUnit,
    String? daysOfWeek,
    int? dayOfMonth,
    String? timeOfDay,
    String? timingTag,
  }) async {
    final body = <String, dynamic>{};

    if (scheduleType != null) {
      body['scheduleType'] =
          scheduleType;
    }

    if (startDate != null) {
      body['startDate'] =
          startDate;
    }

    // Important:
    // If the user removes the end date,
    // send null to the backend.
    if (clearEndDate) {
      body['endDate'] = null;
    } else if (endDate != null) {
      body['endDate'] = endDate;
    }

    if (intervalValue != null) {
      body['intervalValue'] =
          intervalValue;
    }

    if (intervalUnit != null) {
      body['intervalUnit'] =
          intervalUnit;
    }

    if (daysOfWeek != null) {
      body['daysOfWeek'] =
          daysOfWeek;
    }

    if (dayOfMonth != null) {
      body['dayOfMonth'] =
          dayOfMonth;
    }

    if (timeOfDay != null) {
      body['timeOfDay'] =
          timeOfDay;
    }

    if (timingTag != null) {
      body['timingTag'] =
          timingTag;
    }

    final response = await _api.patch(
      '/schedules/$id',
      body: body,
    );

    return Map<String, dynamic>.from(
      response,
    );
  }

  // ==================================================
  // DELETE SCHEDULE
  // ==================================================

  Future<void> deleteSchedule(
    String id,
  ) async {
    await _api.delete(
      '/schedules/$id',
    );
  }
}