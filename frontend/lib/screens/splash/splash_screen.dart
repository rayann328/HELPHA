import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart'; 

import '../../core/constants/app_colors.dart'; 
import '../../services/auth_service.dart'; 
import '../dashboard/dashboard_screen.dart'; 
import '../onboarding/onboarding_screen.dart'; 

class SplashScreen extends StatefulWidget { 
const SplashScreen({super.key}); 

@override 
State<SplashScreen> createState() => _SplashScreenState(); 
} 

class _SplashScreenState extends State<SplashScreen> { 
final AuthService _authService = AuthService(); 

@override 
void initState() { 
super.initState(); 
_startApp(); 
} 

Future<void> _startApp() async { 
await Future.delayed(Duration(seconds: 2)); 

if (!mounted) return; 

final isLoggedIn = await _authService.isLoggedIn(); 

if (!mounted) return; 

Navigator.of(context).pushReplacement( 
MaterialPageRoute( 
builder: (_) => isLoggedIn 
? DashboardScreen() 
: OnboardingScreen(), 
), 
); 
} 

@override 
Widget build(BuildContext context) { 
return Scaffold( 
backgroundColor: AppColors.primary, 
body: Center( 
child: Column( 
mainAxisAlignment: MainAxisAlignment.center, 
children: [ 
Container( 
width: 100, 
height: 100, 
decoration: BoxDecoration( 
color: AppColors.white, 
borderRadius: BorderRadius.circular(28), 
), 
child: Icon( 
Icons.medication_rounded, 
size: 58, 
color: AppColors.primary, 
), 
), 
SizedBox(height: 24), 
Text( 
'HELPHA', 
style: TextStyle( 
color: AppColors.white, 
fontSize: 32, 
fontWeight: FontWeight.bold, 
letterSpacing: 2, 
), 
), 
SizedBox(height: 8), 
Text(AppStrings.get(context, 'yourMedicationCompanion'), 
style: TextStyle( 
color: Colors.white70, 
fontSize: 15, 
), 
), 
SizedBox(height: 40), 
SizedBox( 
width: 28, 
height: 28, 
child: CircularProgressIndicator( 
strokeWidth: 2.5, 
valueColor: AlwaysStoppedAnimation<Color>( 
AppColors.white, 
), 
), 
), 
], 
), 
), 
); 
} 
}