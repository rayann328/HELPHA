import 'package:flutter/material.dart';

class AppStrings {
  static String get(BuildContext context, String key) {
    final isArabic =
        Localizations.localeOf(context).languageCode == 'ar';

    return isArabic
        ? _arabic[key] ?? _english[key] ?? key
        : _english[key] ?? key;
  }

  static bool isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar';
  }

  static const Map<String, String> _english = {
    // General
    'appName': 'HELPHA',
    'today': 'Today',
    'save': 'Save',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'edit': 'Edit',
    'refresh': 'Refresh',
    'retry': 'Retry',
    'yes': 'Yes',
    'no': 'No',
    'loading': 'Loading...',
    'error': 'Error',

    // Navigation
    'home': 'Home',
    'medications': 'Medications',
    'schedule': 'Schedule',
    'reminders': 'Reminders',
    'history': 'History',
    'profile': 'Profile',
    'settings': 'Settings',

    // Home
    'todaysMedications': "Today's Medications",
    'noMedicationToday': 'No medication scheduled for today.',
    'viewAll': 'View All',

    // Medications
    'addMedication': 'Add Medication',
    'medicationName': 'Medication Name',
    'dosage': 'Dosage',
    'strength': 'Strength',
    'type': 'Type',
    'notes': 'Notes',
    'active': 'Active',
    'archived': 'Archived',

    // Schedule
    'noMedicationsToday': 'No medications today',
    'scheduleClear': 'Your schedule is clear for today.',
    'scheduled': 'scheduled',
    'taken': 'Taken',
    'skipped': 'Skipped',
    'missed': 'Missed',
    'delayed': 'Delayed',
    'pending': 'Pending',

    // Reminders
    'noUpcomingReminders': 'No upcoming reminders.',
    'allCaughtUp': 'You are all caught up!',

    // History
    'medicationHistory': 'Medication History',
    'noHistory': 'No medication history yet.',

    // Profile
    'personalInformation': 'Personal Information',
    'security': 'Security',
    'logout': 'Logout',

    // Settings
    'darkMode': 'Dark mode',
    'darkModeDescription':
        'Use dark appearance throughout the app',
    'medicationReminders': 'Medication reminders',
    'medicationRemindersDescription':
        'Enable medication reminders',
    'language': 'Language',
    'english': 'English',
    'arabic': 'Arabic',
    'aboutHelpha': 'About HELPHA',

    // Actions
    'markAsTaken': 'Medication marked as taken.',
    'medicationSkipped': 'Medication skipped.',
    'medicationDelayed': 'Medication marked as delayed.',
    // Auth
'welcomeBack': 'Welcome Back!',
'loginSubtitle': 'Login to continue using HELPHA',
'email': 'Email',
'enterEmail': 'Enter your email',
'password': 'Password',
'enterPassword': 'Enter your password',
'rememberMe': 'Remember me',
'forgotPassword': 'Forgot Password?',
'login': 'Login',
'noAccount': "Don't have an account?",
'createAccount': 'Create Account',

// Common medication actions
'take': 'Take',
'skip': 'Skip',
'details': 'Details',
'close': 'Close',
'confirm': 'Confirm',

// Splash / Onboarding
'medicationCompanion': 'Your medication companion',
'getStarted': 'Get Started',
'next': 'Next',
'skipIntro': 'Skip',

// Errors
'loginFailed': 'Login failed. Please try again.',
'connectionError':
    'Could not connect to the HELPHA server. Make sure the backend is running.',
  };

  static const Map<String, String> _arabic = {
    // General
    'appName': 'HELPHA',
    'today': 'اليوم',
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'delete': 'حذف',
    'edit': 'تعديل',
    'refresh': 'تحديث',
    'retry': 'إعادة المحاولة',
    'yes': 'نعم',
    'no': 'لا',
    'loading': 'جارٍ التحميل...',
    'error': 'خطأ',

    // Navigation
    'home': 'الرئيسية',
    'medications': 'الأدوية',
    'schedule': 'الجدول',
    'reminders': 'التذكيرات',
    'history': 'السجل',
    'profile': 'الملف الشخصي',
    'settings': 'الإعدادات',

    // Home
    'todaysMedications': 'أدوية اليوم',
    'noMedicationToday': 'لا توجد أدوية مجدولة لليوم.',
    'viewAll': 'عرض الكل',

    // Medications
    'addMedication': 'إضافة دواء',
    'medicationName': 'اسم الدواء',
    'dosage': 'الجرعة',
    'strength': 'التركيز',
    'type': 'النوع',
    'notes': 'ملاحظات',
    'active': 'نشط',
    'archived': 'مؤرشف',

    // Schedule
    'noMedicationsToday': 'لا توجد أدوية اليوم',
    'scheduleClear': 'جدولك خالٍ لهذا اليوم.',
    'scheduled': 'مجدول',
    'taken': 'تم التناول',
    'skipped': 'تم التخطي',
    'missed': 'فائت',
    'delayed': 'مؤجل',
    'pending': 'قيد الانتظار',

    // Reminders
    'noUpcomingReminders': 'لا توجد تذكيرات قادمة.',
    'allCaughtUp': 'لقد انتهيت من جميع التذكيرات!',

    // History
    'medicationHistory': 'سجل الأدوية',
    'noHistory': 'لا يوجد سجل للأدوية حتى الآن.',

    // Profile
    'personalInformation': 'المعلومات الشخصية',
    'security': 'الأمان',
    'logout': 'تسجيل الخروج',

    // Settings
    'darkMode': 'الوضع الداكن',
    'darkModeDescription':
        'استخدام المظهر الداكن في جميع أنحاء التطبيق',
    'medicationReminders': 'تذكيرات الأدوية',
    'medicationRemindersDescription':
        'تفعيل تذكيرات الأدوية',
    'language': 'اللغة',
    'english': 'الإنجليزية',
    'arabic': 'العربية',
    'aboutHelpha': 'حول HELPHA',

    // Actions
    'markAsTaken': 'تم تسجيل الدواء كمُتناول.',
    'medicationSkipped': 'تم تخطي الدواء.',
    'medicationDelayed': 'تم تأجيل الدواء.',
    // Auth
'welcomeBack': 'أهلاً بعودتك!',
'loginSubtitle': 'سجّل الدخول للمتابعة باستخدام HELPHA',
'email': 'البريد الإلكتروني',
'enterEmail': 'أدخل بريدك الإلكتروني',
'password': 'كلمة المرور',
'enterPassword': 'أدخل كلمة المرور',
'rememberMe': 'تذكرني',
'forgotPassword': 'نسيت كلمة المرور؟',
'login': 'تسجيل الدخول',
'noAccount': 'ليس لديك حساب؟',
'createAccount': 'إنشاء حساب',

// Common medication actions
'take': 'تناول',
'skip': 'تخطي',
'details': 'التفاصيل',
'close': 'إغلاق',
'confirm': 'تأكيد',

// Splash / Onboarding
'medicationCompanion': 'رفيقك لإدارة الأدوية',
'getStarted': 'ابدأ الآن',
'next': 'التالي',
'skipIntro': 'تخطي',

// Errors
'loginFailed': 'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.',
'connectionError':
    'تعذر الاتصال بخادم HELPHA. تأكد من تشغيل الخادم.',
  };
}