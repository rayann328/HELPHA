import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final _emailController =
      TextEditingController();

  bool _loading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    final email =
        _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final api = ApiService();

      final response = await api.post(
        '/auth/forgot-password',
        body: {
          'email': email,
        },
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
        _emailSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response is Map &&
                    response['message'] != null
                ? response['message'].toString()
                : 'Password reset request sent',
          ),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _emailSent
            ? Center(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.mark_email_read,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Reset request sent',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please check your email for the password reset instructions.',
                      textAlign:
                          TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child:
                          const Text('Back to Login'),
                    ),
                  ],
                ),
              )
            : ListView(
                children: [
                  const Text(
                    'Reset your password',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter your email and we will send you instructions to reset your password.',
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller:
                        _emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(
                      labelText: 'Email',
                      prefixIcon:
                          Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          _loading
                              ? null
                              : _sendReset,
                      child: _loading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                            )
                          : const Text(
                              'Send Reset Link',
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}