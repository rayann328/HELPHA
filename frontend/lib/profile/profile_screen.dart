import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import 'notifications_screen.dart';
import 'personal_info_screen.dart';
import 'security_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final ProfileService _profileService =
      ProfileService();

  final AuthService _authService =
      AuthService();

  String _name = 'Loading...';
  String _email = '';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile =
          await _profileService.getProfile();

      if (!mounted) return;

      final firstName =
          profile['firstName']?.toString() ?? '';

      final lastName =
          profile['lastName']?.toString() ?? '';

      final fullName =
          '$firstName $lastName'.trim();

      setState(() {
        _name = fullName.isEmpty
            ? 'User'
            : fullName;

        _email =
            profile['email']?.toString() ?? '';

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _name = 'User';
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void _openPage(Widget page) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );

    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                CircleAvatar(
                  radius: 44,
                  child: Text(
                    _name.isNotEmpty
                        ? _name[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Center(
                  child: Text(
                    _email,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Card(
                  child: ListTile(
                    leading:
                        const Icon(Icons.person),
                    title: const Text(
                      'Personal Information',
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      _openPage(
                        const PersonalInfoScreen(),
                      );
                    },
                  ),
                ),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications,
                    ),
                    title: const Text(
                      'Notifications',
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      _openPage(
                        const NotificationsScreen(),
                      );
                    },
                  ),
                ),

                Card(
                  child: ListTile(
                    leading:
                        const Icon(Icons.security),
                    title: const Text(
                      'Security',
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      _openPage(
                        const SecurityScreen(),
                      );
                    },
                  ),
                ),

                Card(
                  child: ListTile(
                    leading:
                        const Icon(Icons.settings),
                    title: const Text(
                      'Settings',
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      _openPage(
                        const SettingsScreen(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.logout,
                  ),
                  label: const Text('Logout'),
                ),
              ],
            ),
    );
  }
}