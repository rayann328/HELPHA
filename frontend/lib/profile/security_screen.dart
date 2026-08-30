import 'package:flutter/material.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool biometricLogin = false;
  bool twoFactorAuthentication = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: const Text('Biometric Login'),
              subtitle: const Text(
                'Use fingerprint or face recognition to log in',
              ),
              value: biometricLogin,
              onChanged: (value) {
                setState(() {
                  biometricLogin = value;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.verified_user_outlined),
              title: const Text('Two-Factor Authentication'),
              subtitle: const Text(
                'Add an extra layer of account security',
              ),
              value: twoFactorAuthentication,
              onChanged: (value) {
                setState(() {
                  twoFactorAuthentication = value;
                });
              },
            ),
          ),

          const SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_reset),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Change password coming next'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}