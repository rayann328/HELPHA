# HELPHA 💊

HELPHA is a medication management mobile application designed to help users organize their medications, schedules, reminders, and medication history in one place.

The application focuses on making medication management simple, organized, and reliable. It provides users with medication scheduling, reminders, dose tracking, calendar views, history, and profile/settings management.

---

## 📱 Core Pages

HELPHA includes the following main pages:

1. Splash Screen
2. Onboarding
3. Login
4. Register
5. Forgot Password
6. Home Dashboard
7. Today's Medications
8. Medication List
9. Medication Details
10. Add Medication
11. Edit Medication
12. Medication Schedule
13. Calendar
14. Medication History
15. Profile
16. Settings

---

## ✨ Main Features

### 🔐 Authentication

- User registration
- User login
- Forgot password / password reset
- Authentication-protected application pages
- Secure authentication using JWT

### 🏠 Dashboard

The dashboard provides an overview of the user's medication activity.

Features include:

- Today's medications
- Upcoming medications
- Medication completion status
- Missed medications
- Daily medication overview
- Quick access to medication management

### 💊 Medication Management

Users can manage their medications through the application.

Features include:

- Add medication
- Edit medication
- View medication details
- Delete/archive medication
- Medication name
- Dosage
- Medication type
- Notes
- Medication status

Supported medication types include:

- Tablet
- Capsule
- Syrup
- Injection
- Drops
- Spray
- Cream
- Gel
- Inhaler
- Patch
- Vitamins
- Supplements
- Other

### 🗓️ Smart Scheduling

HELPHA supports different medication scheduling options:

- Daily schedules
- Weekly schedules
- Monthly schedules
- Custom recurring schedules
- One-time schedules
- Interval-based schedules
- Start dates
- End dates
- Specific medication times

The scheduling system automatically creates dose records for scheduled medications.

### 🔔 Reminders

The reminder system provides users with upcoming medication reminders.

Current functionality includes:

- Upcoming medication reminders
- Today's medication reminders
- Reminder status tracking
- Marking medication as taken
- Skipping a medication
- Delaying a medication
- Marking a medication as missed
- Adding notes to a dose

### 📊 Medication Tracking

Users can track the status of individual medication doses:

- Taken
- Skipped
- Delayed
- Missed
- Pending

Completed medication actions are stored in the medication history.

### 📅 Calendar

The calendar provides a date-based view of medication schedules and dose activity.

Planned calendar functionality includes:

- Daily view
- Weekly view
- Monthly view
- Upcoming doses
- Completed doses
- Missed doses
- Medication history

### 📜 Medication History

The History section records completed medication actions.

History can include:

- Taken medications
- Skipped medications
- Delayed medications
- Missed medications
- Medication name
- Scheduled date and time
- Dose status

### 👤 Profile

Users can manage their profile information.

Features include:

- View profile information
- Edit personal information
- Manage account information

### ⚙️ Settings

The settings section is intended to provide control over application preferences.

Planned settings include:

- Notification preferences
- Notification sound
- Snooze duration
- Vibration
- Passcode protection
- Biometric authentication
- Cloud backup and restore

---

# 🏗️ Project Architecture

HELPHA is divided into two main parts:

```text
HELPHA/
│
├── frontend/
│   └── Flutter Mobile Application
│
├── backend/
│   └── NestJS REST API
│
└── README.md