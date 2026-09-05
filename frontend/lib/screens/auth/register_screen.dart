import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart'; 

import '../../core/constants/app_colors.dart'; 
import '../../services/auth_service.dart'; 

class RegisterScreen extends StatefulWidget { 
const RegisterScreen({super.key}); 

@override 
State<RegisterScreen> createState() => _RegisterScreenState(); 
} 

class _RegisterScreenState extends State<RegisterScreen> { 
final _formKey = GlobalKey<FormState>(); 

final _nameController = TextEditingController(); 
final _emailController = TextEditingController(); 
final _passwordController = TextEditingController(); 
final _confirmPasswordController = TextEditingController(); 

final AuthService _authService = AuthService(); 

bool _obscurePassword = true; 
bool _obscureConfirmPassword = true; 
bool _agreeToTerms = false; 
bool _isLoading = false; 

@override 
void dispose() { 
_nameController.dispose(); 
_emailController.dispose(); 
_passwordController.dispose(); 
_confirmPasswordController.dispose(); 
super.dispose(); 
} 

Future<void> _register() async { 
if (!_formKey.currentState!.validate()) { 
return; 
} 

if (!_agreeToTerms) { 
ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: Text(AppStrings.get(context, 'agreeTerms'), 
), 
), 
); 
return; 
} 

setState(() { 
_isLoading = true; 
}); 

final result = await _authService.register( 
fullName: _nameController.text, 
email: _emailController.text, 
password: _passwordController.text, 
); 

if (!mounted) { 
return; 
} 

setState(() { 
_isLoading = false; 
}); 

if (result['success'] == true) { 
ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: Text( 
result['message']?.toString() ?? 
'Registration successful!', 
), 
), 
); 

await Future.delayed(Duration(milliseconds: 500)); 

if (!mounted) { 
return; 
} 

Navigator.pop(context); 
return; 
} 

ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: Text( 
result['message']?.toString() ?? 
'Registration failed. Please try again.', 
), 
), 
); 
} 

@override 
Widget build(BuildContext context) { 
return Scaffold( 
appBar: AppBar( 
title: Text(AppStrings.get(context, 'createAccount')), 
), 
body: SafeArea( 
child: SingleChildScrollView( 
padding: EdgeInsets.symmetric( 
horizontal: 24, 
vertical: 20, 
), 
child: Form( 
key: _formKey, 
child: Column( 
crossAxisAlignment: CrossAxisAlignment.start, 
children: [ 
SizedBox(height: 10), 

Text(AppStrings.get(context, 'createYourAccount'), 
style: TextStyle( 
fontSize: 28, 
fontWeight: FontWeight.bold, 
color: AppColors.textPrimary, 
), 
), 

SizedBox(height: 8), 

Text(AppStrings.get(context, 'createAccountSubtitle'), 
style: TextStyle( 
fontSize: 15, 
color: AppColors.textSecondary, 
), 
), 

SizedBox(height: 30), 

Text(AppStrings.get(context, 'fullName'), 
style: TextStyle( 
fontSize: 14, 
fontWeight: FontWeight.w600, 
), 
), 

SizedBox(height: 8), 

TextFormField( 
controller: _nameController, 
enabled: !_isLoading, 
textInputAction: TextInputAction.next, 
decoration: InputDecoration( 
hintText: AppStrings.get(context, 'enterFullName'), 
prefixIcon: Icon(Icons.person_outline), 
), 
validator: (value) { 
if (value == null || value.trim().isEmpty) { 
return 'Please enter your name'; 
} 

return null; 
}, 
), 

SizedBox(height: 18), 

Text(AppStrings.get(context, 'email'), 
style: TextStyle( 
fontSize: 14, 
fontWeight: FontWeight.w600, 
), 
), 

SizedBox(height: 8), 

TextFormField( 
controller: _emailController, 
enabled: !_isLoading, 
keyboardType: TextInputType.emailAddress, 
textInputAction: TextInputAction.next, 
decoration: InputDecoration( 
hintText: AppStrings.get(context, 'enterEmail'), 
prefixIcon: Icon(Icons.email_outlined), 
), 
validator: (value) { 
if (value == null || value.trim().isEmpty) { 
return AppStrings.get(context, 'pleaseEnterEmail'); 
} 

if (!value.contains('@')) { 
return AppStrings.get(context, 'invalidEmail'); 
} 

return null; 
}, 
), 

SizedBox(height: 18), 

Text(AppStrings.get(context, 'password'), 
style: TextStyle( 
fontSize: 14, 
fontWeight: FontWeight.w600, 
), 
), 

SizedBox(height: 8), 

TextFormField( 
controller: _passwordController, 
enabled: !_isLoading, 
obscureText: _obscurePassword, 
textInputAction: TextInputAction.next, 
decoration: InputDecoration( 
hintText: AppStrings.get(context, 'createPassword'), 
prefixIcon: Icon(Icons.lock_outline), 
suffixIcon: IconButton( 
onPressed: _isLoading 
? null 
: () { 
setState(() { 
_obscurePassword = 
!_obscurePassword; 
}); 
}, 
icon: Icon( 
_obscurePassword 
? Icons.visibility_outlined 
: Icons.visibility_off_outlined, 
), 
), 
), 
validator: (value) { 
if (value == null || value.isEmpty) { 
return 'Please enter a password'; 
} 

if (value.length < 8) { 
return AppStrings.get(context, 'passwordEight'); 
} 

return null; 
}, 
), 

SizedBox(height: 18), 

Text(AppStrings.get(context, 'confirmPassword'), 
style: TextStyle( 
fontSize: 14, 
fontWeight: FontWeight.w600, 
), 
), 

SizedBox(height: 8), 

TextFormField( 
controller: _confirmPasswordController, 
enabled: !_isLoading, 
obscureText: _obscureConfirmPassword, 
decoration: InputDecoration( 
hintText: AppStrings.get(context, 'confirmYourPassword'), 
prefixIcon: Icon(Icons.lock_outline), 
suffixIcon: IconButton( 
onPressed: _isLoading 
? null 
: () { 
setState(() { 
_obscureConfirmPassword = 
!_obscureConfirmPassword; 
}); 
}, 
icon: Icon( 
_obscureConfirmPassword 
? Icons.visibility_outlined 
: Icons.visibility_off_outlined, 
), 
), 
), 
validator: (value) { 
if (value == null || value.isEmpty) { 
return 'Please confirm your password'; 
} 

if (value != _passwordController.text) { 
return 'Passwords do not match'; 
} 

return null; 
}, 
), 

SizedBox(height: 18), 

Row( 
crossAxisAlignment: CrossAxisAlignment.start, 
children: [ 
Checkbox( 
value: _agreeToTerms, 
onChanged: _isLoading 
? null 
: (value) { 
setState(() { 
_agreeToTerms = value ?? false; 
}); 
}, 
), 
Expanded( 
child: Padding( 
padding: EdgeInsets.only(top: 12), 
child: Text(AppStrings.get(context, 'terms'), 
style: TextStyle( 
fontSize: 13, 
color: AppColors.textSecondary, 
), 
), 
), 
), 
], 
), 

SizedBox(height: 20), 

ElevatedButton( 
onPressed: _isLoading ? null : _register, 
child: _isLoading 
? SizedBox( 
width: 24, 
height: 24, 
child: CircularProgressIndicator( 
strokeWidth: 2.5, 
color: Colors.white, 
), 
) 
: Text(AppStrings.get(context, 'createAccount'), 
style: TextStyle( 
fontSize: 16, 
fontWeight: FontWeight.w600, 
), 
), 
), 

SizedBox(height: 20), 

Center( 
child: TextButton( 
onPressed: _isLoading 
? null 
: () { 
Navigator.pop(context); 
}, 
child: Text(AppStrings.get(context, 'alreadyHaveAccount'), 
), 
), 
), 
], 
), 
), 
), 
), 
); 
} 
}