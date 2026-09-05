import 'package:flutter/material.dart'; 

class AppSettings { 
static final ValueNotifier<ThemeMode> themeMode = 
ValueNotifier<ThemeMode>( 
ThemeMode.light, 
); 

static final ValueNotifier<Locale> locale = 
ValueNotifier<Locale>( 
const Locale('en'), 
); 

static bool medicationReminders = true; 

static void setDarkMode( 
bool enabled, 
) { 
themeMode.value = enabled 
? ThemeMode.dark 
: ThemeMode.light; 
} 

static void setLanguage( 
String language, 
) { 
locale.value = language == 'ar' 
? const Locale('ar') 
: const Locale('en'); 
} 
}
