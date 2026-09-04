import 'api_service.dart';

class SettingsService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>>
      getSettings() async {
    final response =
        await _api.get('/settings');

    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>>
      updateSettings({
    bool? darkMode,
    String? language,
    bool? medicationReminders,
    bool? notificationSound,
    bool? vibration,
    int? snoozeDuration,
    bool? biometricEnabled,
    bool? twoFactorEnabled,
  }) async {
    final body = <String, dynamic>{};

    if (darkMode != null) {
      body['darkMode'] = darkMode;
    }

    if (language != null) {
      body['language'] = language;
    }

    if (medicationReminders != null) {
      body['medicationReminders'] =
          medicationReminders;
    }

    if (notificationSound != null) {
      body['notificationSound'] =
          notificationSound;
    }

    if (vibration != null) {
      body['vibration'] = vibration;
    }

    if (snoozeDuration != null) {
      body['snoozeDuration'] =
          snoozeDuration;
    }

    if (biometricEnabled != null) {
      body['biometricEnabled'] =
          biometricEnabled;
    }

    if (twoFactorEnabled != null) {
      body['twoFactorEnabled'] =
          twoFactorEnabled;
    }

    final response = await _api.patch(
      '/settings',
      body: body,
    );

    return Map<String, dynamic>.from(response);
  }
}