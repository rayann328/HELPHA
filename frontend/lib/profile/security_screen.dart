import 'package:flutter/material.dart';
import '../core/localization/app_strings.dart'; 

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
SnackBar( 
content: 
Text(AppStrings.get(context, 'fillPasswordFields')), 
), 
); 
return; 
} 

if (newPassword.length < 8) { 
ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: Text(AppStrings.get(context, 'passwordMinimum'), 
), 
), 
); 
return; 
} 

if (newPassword != confirm) { 
ScaffoldMessenger.of(context).showSnackBar( 
SnackBar( 
content: 
Text(AppStrings.get(context, 'passwordsDoNotMatch')), 
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
SnackBar( 
content: 
Text(AppStrings.get(context, 'passwordChanged')), 
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
return Scaffold( 
body: Center( 
child: CircularProgressIndicator(), 
), 
); 
} 

return Scaffold( 
appBar: AppBar( 
title: Text(AppStrings.get(context, 'security')), 
), 
body: ListView( 
padding: EdgeInsets.all(16), 
children: [ 
Text(AppStrings.get(context, 'securityOptions'), 
style: TextStyle( 
fontSize: 20, 
fontWeight: FontWeight.bold, 
), 
), 

SizedBox(height: 12), 

Card( 
child: SwitchListTile( 
title: 
Text(AppStrings.get(context, 'biometricLogin')), 
subtitle: Text(AppStrings.get(context, 'biometricDescription'), 
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
title: Text(AppStrings.get(context, 'twoFactor'), 
), 
subtitle: Text(AppStrings.get(context, 'twoFactorDescription'), 
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

SizedBox(height: 28), 

Text(AppStrings.get(context, 'changePassword'), 
style: TextStyle( 
fontSize: 20, 
fontWeight: FontWeight.bold, 
), 
), 

SizedBox(height: 12), 

TextField( 
controller: 
_currentPasswordController, 
obscureText: true, 
decoration: InputDecoration( 
labelText: AppStrings.get(context, 'currentPassword'), 
), 
), 

SizedBox(height: 12), 

TextField( 
controller: 
_newPasswordController, 
obscureText: true, 
decoration: InputDecoration( 
labelText: AppStrings.get(context, 'newPassword'), 
), 
), 

SizedBox(height: 12), 

TextField( 
controller: 
_confirmPasswordController, 
obscureText: true, 
decoration: InputDecoration( 
labelText: AppStrings.get(context, 'confirmNewPassword'), 
), 
), 

SizedBox(height: 20), 

SizedBox( 
height: 50, 
child: ElevatedButton( 
onPressed: _changePassword, 
child: 
Text(AppStrings.get(context, 'changePassword')), 
), 
), 
], 
), 
); 
} 
}

