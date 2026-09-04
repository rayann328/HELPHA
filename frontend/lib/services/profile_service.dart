import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class ProfileService {
  static const String baseUrl = AuthService.baseUrl;

  Future<Map<String, dynamic>> getProfile() async {
    final token = await AuthService().getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
          as Map<String, dynamic>;
    }

    throw Exception(
      'Failed to load profile: ${response.body}',
    );
  }

  Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? dateOfBirth,
  }) async {
    final token = await AuthService().getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final body = <String, dynamic>{};

    if (firstName != null) {
      body['firstName'] = firstName;
    }

    if (lastName != null) {
      body['lastName'] = lastName;
    }

    if (phone != null) {
      body['phone'] = phone;
    }

    if (dateOfBirth != null) {
      body['dateOfBirth'] = dateOfBirth;
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return jsonDecode(response.body)
          as Map<String, dynamic>;
    }

    throw Exception(
      'Failed to update profile: ${response.body}',
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = await AuthService().getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/profile/password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      String message = 'Failed to change password';

      try {
        final data =
            jsonDecode(response.body)
                as Map<String, dynamic>;

        if (data['message'] != null) {
          message = data['message'].toString();
        }
      } catch (_) {}

      throw Exception(message);
    }
  }
}