import 'package:flutter/material.dart';

import '../services/profile_service.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() =>
      _PersonalInfoScreenState();
}

class _PersonalInfoScreenState
    extends State<PersonalInfoScreen> {
  final ProfileService _service =
      ProfileService();

  final _firstNameController =
      TextEditingController();

  final _lastNameController =
      TextEditingController();

  final _emailController =
      TextEditingController();

  final _phoneController =
      TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile =
          await _service.getProfile();

      if (!mounted) return;

      setState(() {
        _firstNameController.text =
            profile['firstName']?.toString() ?? '';

        _lastNameController.text =
            profile['lastName']?.toString() ?? '';

        _emailController.text =
            profile['email']?.toString() ?? '';

        _phoneController.text =
            profile['phone']?.toString() ?? '';

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });

    try {
      await _service.updateProfile(
        firstName:
            _firstNameController.text,
        lastName:
            _lastNameController.text,
        phone: _phoneController.text,
      );

      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Profile updated successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _saving = false;
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
        title: const Text('Personal Information'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _firstNameController,
            decoration: const InputDecoration(
              labelText: 'First name',
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last name',
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _emailController,
            enabled: false,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone',
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed:
                  _saving ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator(
                      strokeWidth: 2,
                    )
                  : const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}