import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../screens/auth/login_screen.dart';

import 'personal_info_screen.dart';
import 'notifications_screen.dart';
import 'security_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const SizedBox(height: 20),

          // =====================================================
          // PROFILE IMAGE
          // =====================================================

          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.person,
                size: 55,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // =====================================================
          // USER NAME
          // =====================================================

          Center(
            child: Text(
              'Your Name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // =====================================================
          // USER EMAIL
          // =====================================================

          Center(
            child: Text(
              'user@example.com',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // =====================================================
          // PERSONAL INFORMATION
          // =====================================================

          _SettingTile(
            icon: Icons.person_outline,
            title: 'Personal Information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PersonalInfoScreen(),
                ),
              );
            },
          ),

          // =====================================================
          // NOTIFICATIONS
          // =====================================================

          _SettingTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
          ),

          // =====================================================
          // SECURITY
          // =====================================================

          _SettingTile(
            icon: Icons.lock_outline,
            title: 'Security',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SecurityScreen(),
                ),
              );
            },
          ),

          // =====================================================
          // SETTINGS
          // =====================================================

          _SettingTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // =====================================================
          // LOGOUT
          // =====================================================

          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },

            icon: const Icon(
              Icons.logout,
              color: AppColors.error,
            ),

            label: const Text(
              'Logout',
              style: TextStyle(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===============================================================
// SETTING TILE
// ===============================================================

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,

      margin: const EdgeInsets.only(bottom: 10),

      // IMPORTANT:
      // Do NOT use Colors.white here.
      // The Card will automatically use the current theme.
      color: colorScheme.surface,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),

      child: ListTile(
        leading: Icon(
          icon,
          color: colorScheme.primary,
        ),

        title: Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),

        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurfaceVariant,
        ),

        onTap: onTap,
      ),
    );
  }
}