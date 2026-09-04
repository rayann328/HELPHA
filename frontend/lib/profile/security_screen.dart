import 'package:flutter/material.dart';

import '../services/profile_service.dart';
import '../services/settings_service.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() =>
      _SecurityScreenState();
}

class _SecurityScreenState
    extends State<SecurityScreen> {
  final ProfileService _profileService =
      ProfileService();

  final SettingsService _settingsService =
      SettingsService();

  bool _biometricLogin = false;
  bool _twoFactorAuthentication = false;

  bool _loading = true;

  final _currentPasswordController =
      TextEditingController();

  final _newPasswordController =
      TextEditingController();

  final _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings =
          await _settingsService.getSettings();

      if (!mounted) return;

      setState(() {
        _biometricLogin =
            settings['biometricEnabled'] ?? false;

        _twoFactorAuthentication =
            settings['twoFactorEnabled'] ?? false;

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    final current =
        _currentPasswordController.text;

    final newPassword =
        _newPasswordController.text;

    final confirm =
        _confirmPasswordController.text;

    if (current.isEmpty ||
        newPassword.isEmpty ||
        confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please fill all password fields'),
        ),
      );
      return;
    }

    if (newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'New password must be at least 8 characters',
          ),
        ),
      );
      return;
    }

    if (newPassword != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Passwords do not match'),
        ),
      );
      return;
    }

    try {
      await _profileService.changePassword(
        currentPassword: current,
        newPassword: newPassword,
      );

      if (!mounted) return;

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Password changed successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _updateSecuritySettings({
    bool? biometric,
    bool? twoFactor,
  }) async {
    final oldBiometric = _biometricLogin;
    final oldTwoFactor =
        _twoFactorAuthentication;

    setState(() {
      if (biometric != null) {
        _biometricLogin = biometric;
      }

      if (twoFactor != null) {
        _twoFactorAuthentication = twoFactor;
      }
    });

    try {
      await _settingsService.updateSettings(
        biometricEnabled: biometric,
        twoFactorEnabled: twoFactor,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _biometricLogin = oldBiometric;
        _twoFactorAuthentication =
            oldTwoFactor;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Security Options',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            child: SwitchListTile(
              title:
                  const Text('Biometric login'),
              subtitle: const Text(
                'Use biometric authentication when available',
              ),
              value: _biometricLogin,
              onChanged: (value) {
                _updateSecuritySettings(
                  biometric: value,
                );
              },
            ),
          ),

          Card(
            child: SwitchListTile(
              title: const Text(
                'Two-factor authentication',
              ),
              subtitle: const Text(
                'Add another layer of account security',
              ),
              value:
                  _twoFactorAuthentication,
              onChanged: (value) {
                _updateSecuritySettings(
                  twoFactor: value,
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'Change Password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller:
                _currentPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Current password',
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller:
                _newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New password',
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller:
                _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm new password',
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _changePassword,
              child:
                  const Text('Change Password'),
            ),
          ),
        ],
      ),
    );
  }
}