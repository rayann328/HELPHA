import 'api_service.dart';

class NotificationService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>>
      getNotifications() async {
    final response =
        await _api.get('/notifications');

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

  Future<Map<String, dynamic>>
      getNotification(String id) async {
    final response =
        await _api.get('/notifications/$id');

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>>
      createNotification({
    required String title,
    required String message,
    String? type,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'message': message,
    };

    if (type != null) {
      body['type'] = type;
    }

    final response = await _api.post(
      '/notifications',
      body: body,
    );

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>>
      updateNotification(
    String id, {
    String? title,
    String? message,
    String? type,
    bool? isRead,
  }) async {
    final body = <String, dynamic>{};

    if (title != null) {
      body['title'] = title;
    }

    if (message != null) {
      body['message'] = message;
    }

    if (type != null) {
      body['type'] = type;
    }

    if (isRead != null) {
      body['isRead'] = isRead;
    }

    final response = await _api.patch(
      '/notifications/$id',
      body: body,
    );

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>>
      markAsRead(String id) async {
    final response =
        await _api.patch(
      '/notifications/$id/read',
    );

    return Map<String, dynamic>.from(response);
  }

  Future<void> deleteNotification(
    String id,
  ) async {
    await _api.delete(
      '/notifications/$id',
    );
  }
}