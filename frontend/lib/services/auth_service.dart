import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000';

  static const String _tokenKey = 'access_token';
  static const String _emailKey = 'user_email';

  // =========================
  // LOGIN
  // =========================
Future<Map<String, dynamic>> login({
  required String email,
  required String password,
  required bool rememberMe,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    final Map<String, dynamic> data =
        response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>
            : {};

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      final accessToken = data['access_token'];

      if (accessToken == null ||
          accessToken.toString().isEmpty) {
        return {
          'success': false,
          'message':
              'Login succeeded, but no access token was received.',
        };
      }

      final prefs =
          await SharedPreferences.getInstance();

      // Always save the token during the current app session.
      await prefs.setString(
        _tokenKey,
        accessToken.toString(),
      );

      // Remember me controls whether the email is remembered
      // for the next login / app launch.
      if (rememberMe) {
        await prefs.setString(
          _emailKey,
          email.trim(),
        );
      } else {
        await prefs.remove(_emailKey);
      }

      return {
        'success': true,
        'message':
            data['message'] ?? 'Login successful',
        'access_token': accessToken,
        'user': data['user'],
      };
    }

    return {
      'success': false,
      'message': _extractMessage(data),
    };
  } catch (e) {
    return {
      'success': false,
      'message':
          'Could not connect to the HELPHA server. '
          'Make sure the backend is running.',
    };
  }
}

  // =========================
  // REGISTER
  // =========================

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final nameParts =
          fullName.trim().split(RegExp(r'\s+'));

      final firstName =
          nameParts.isNotEmpty ? nameParts.first : '';

      final lastName =
          nameParts.length > 1
              ? nameParts.sublist(1).join(' ')
              : '';

      final Map<String, dynamic> body = {
        'email': email.trim(),
        'password': password,
        'firstName': firstName,
      };

      if (lastName.isNotEmpty) {
        body['lastName'] = lastName;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final Map<String, dynamic> data =
          response.body.isNotEmpty
              ? jsonDecode(response.body) as Map<String, dynamic>
              : {};

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return {
          'success': true,
          'message':
              data['message'] ?? 'Registration successful',
          'verificationToken':
              data['verificationToken'],
          'user': data['user'],
          'access_token':
              data['access_token'],
        };
      }

      return {
        'success': false,
        'message': _extractMessage(data),
      };
    } catch (e) {
      return {
        'success': false,
        'message':
            'Could not connect to the HELPHA server. '
            'Make sure the backend is running.',
      };
    }
  }

  // =========================
  // ERROR MESSAGE
  // =========================

  String _extractMessage(
    Map<String, dynamic> data,
  ) {
    final message = data['message'];

    if (message is String &&
        message.isNotEmpty) {
      return message;
    }

    if (message is List &&
        message.isNotEmpty) {
      return message.first.toString();
    }

    return 'Something went wrong. Please try again.';
  }

  // =========================
  // TOKEN
  // =========================

  Future<String?> getToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(_tokenKey);
  }

  // =========================
  // SAVED EMAIL
  // =========================

  Future<String?> getSavedEmail() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(_emailKey);
  }

  // =========================
  // CHECK LOGIN
  // =========================

  Future<bool> isLoggedIn() async {
    final token = await getToken();

    return token != null && token.isNotEmpty;
  }

  // =========================
  // LOGOUT
  // =========================

  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);
    await prefs.remove(_emailKey);
  }
}