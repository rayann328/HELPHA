import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart'; 

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
SnackBar( 
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
title: Text(AppStrings.get(context, 'forgotPasswordTitle')), 
), 
body: Padding( 
padding: EdgeInsets.all(24), 
child: _emailSent 
? Center( 
child: Column( 
mainAxisSize: 
MainAxisSize.min, 
children: [ 
Icon( 
Icons.mark_email_read, 
size: 64, 
), 
SizedBox(height: 16), 
Text(AppStrings.get(context, 'resetRequestSent'), 
style: TextStyle( 
fontSize: 22, 
fontWeight: 
FontWeight.bold, 
), 
), 
SizedBox(height: 8), 
Text(AppStrings.get(context, 'checkEmail'), 
textAlign: 
TextAlign.center, 
), 
SizedBox(height: 24), 
ElevatedButton( 
onPressed: () => 
Navigator.pop(context), 
child: 
Text(AppStrings.get(context, 'backToLogin')), 
), 
], 
), 
) 
: ListView( 
children: [ 
Text(AppStrings.get(context, 'resetYourPassword'), 
style: TextStyle( 
fontSize: 26, 
fontWeight: 
FontWeight.bold, 
), 
), 
SizedBox(height: 10), 
Text(AppStrings.get(context, 'resetPasswordDescription'), 
), 
SizedBox(height: 28), 
TextField( 
controller: 
_emailController, 
keyboardType: 
TextInputType.emailAddress, 
decoration: 
InputDecoration( 
labelText: AppStrings.get(context, 'email'), 
prefixIcon: 
Icon(Icons.email), 
), 
), 
SizedBox(height: 24), 
SizedBox( 
height: 52, 
child: ElevatedButton( 
onPressed: 
_loading 
? null 
: _sendReset, 
child: _loading 
? CircularProgressIndicator( 
strokeWidth: 2, 
) 
: Text(AppStrings.get(context, 'sendResetLink'), 
), 
), 
), 
], 
), 
), 
); 
} 
} // no reset password screen