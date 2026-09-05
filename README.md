# 💊 HELPHA — Medication Management Application

HELPHA is a medication management mobile application designed to help users organize their medications, create medication schedules, receive reminders, track medication doses, and review their medication history.

The project follows a **separate frontend and backend architecture**, allowing the mobile application, backend services, and database to be developed and maintained independently.

---

## 📱 Frontend — Mobile Application

### Technology

* Flutter
* Dart

Flutter provides a single codebase for developing the application for Android and iOS.

### Main Frontend Responsibilities

The Flutter application handles:

* User interface
* Navigation
* Authentication screens
* Medication management
* Medication schedules
* Reminders
* Calendar
* Medication history
* Profile
* Settings
* Communication with the backend API

### Main Flutter Structure

```text
frontend/
└── lib/
    ├── core/
    ├── models/
    ├── services/
    ├── auth/
    ├── medications/
    ├── reminders/
    ├── calendar/
    ├── history/
    ├── profile/
    └── ...
```

---

# 🖥️ Backend

### Technology

* Node.js
* NestJS
* TypeScript
* REST API
* JWT Authentication
* Prisma ORM

The backend follows a modular architecture to separate application functionality into independent modules.

### Main Backend Modules

* Authentication
* Users
* Medications
* Schedules
* Reminders
* History
* Profile
* Settings

### Backend Responsibilities

The backend handles:

* Authentication
* User management
* Medication data
* Medication schedules
* Dose logs
* Reminder data
* Medication history
* API validation
* Authorization
* Database communication

---

# 🗄️ Database

### Database

PostgreSQL

### ORM

Prisma

The database uses a relational structure connecting users, medications, schedules, and dose logs.

### Database Relationship

```text
User
 │
 ├── Medications
 │      │
 │      └── Schedules
 │
 └── Dose Logs
```

### Main Database Models

* User
* Medication
* Schedule
* DoseLog
* Notification
* NotificationPreferences
* UserSettings

The database is designed to maintain medication schedules and track individual medication doses.

---

# 🔌 API Communication

The Flutter frontend communicates with the NestJS backend through REST API endpoints.

### Main API Areas

```text
/auth
/users
/medications
/schedules
/reminders
/history
```

Authentication-protected endpoints require a valid authenticated user.

The backend validates requests and ensures that users can only access their own protected medication-related data.

---

# 🔐 Authentication

HELPHA provides an authentication system for protecting user accounts and application data.

Current authentication functionality includes:

* User registration
* User login
* JWT-based authentication
* Protected API endpoints
* User-specific data access
* Password protection

Additional authentication features may be expanded in future versions.

---

# 💊 Medication Management

HELPHA allows users to manage their medications from the mobile application.

Users can:

* Add medications
* View medications
* Edit medications
* Archive medications
* View medication details
* Add dosage information
* Specify medication type
* Add notes
* Create medication schedules

Medication information can include:

* Medication name
* Generic name
* Brand name
* Dosage
* Strength
* Medication type
* Color
* Shape
* Notes
* Photo

---

# 📅 Medication Scheduling

HELPHA supports medication scheduling to help users organize when medications should be taken.

Supported schedule types include:

* Daily
* Weekly
* Monthly
* Custom recurring schedules
* Interval-based schedules
* One-time schedules

Schedules can include:

* Start date
* End date
* Time of day
* Days of the week
* Day of the month
* Repeating intervals
* Timing information

The scheduling system generates medication dose records that can later be tracked through the reminder and history systems.

---

# 🔔 Reminders

The reminder system allows users to view upcoming and scheduled medication doses.

Reminder-related functionality includes:

* Upcoming medication reminders
* Today's medication reminders
* Medication reminder status
* Dose confirmation
* Skipping a dose
* Delaying a dose
* Marking a dose as missed
* Pending doses

Supported dose statuses include:

```text
PENDING
TAKEN
SKIPPED
DELAYED
MISSED
```

---

# 📊 Dose Tracking

HELPHA tracks individual medication doses.

Users can record whether a scheduled medication dose was:

* Taken
* Skipped
* Delayed
* Missed

Dose records contain information such as:

* Medication
* Schedule
* Scheduled date and time
* Dose status
* Taken date and time
* Notes

This allows the application to maintain a history of medication activity.

---

# 📖 Medication History

The History section allows users to review medication-related dose activity.

The system stores completed medication actions and connects them with:

* Medication
* Schedule
* Dose
* Status
* Date and time
* Notes

This provides users with a record of their medication activity.

---

# 📆 Calendar

The calendar section provides a date-based view of medication schedules and medication activity.

The calendar is designed to help users understand:

* Scheduled medications
* Upcoming doses
* Completed doses
* Missed doses
* Medication activity by date

---

# 🏠 Dashboard

The HELPHA dashboard provides an overview of the user's medication activity.

The dashboard can include:

* Today's medications
* Upcoming medication
* Medication schedules
* Medication reminders
* Medication completion information
* Quick access to medication management

The dashboard acts as the main entry point to the medication-management workflow.

---

# 👤 Profile

The Profile section allows users to manage their account information.

Profile functionality includes:

* Viewing profile information
* Editing personal information
* Managing account-related information
* Accessing application settings

---

# ⚙️ Settings

The Settings section provides options for managing application preferences.

Settings can include:

* Notification preferences
* Reminder preferences
* Account settings
* Security settings
* Application preferences

Additional settings can be added as the project continues to evolve.

---

# 📱 Main Application Screens

The application contains the following main screens and sections:

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

# 🏗️ Project Architecture

HELPHA follows a separated frontend/backend architecture.

```text
┌─────────────────────────┐
│     Flutter Mobile App  │
│        Dart             │
└────────────┬────────────┘
             │
             │ REST API
             ▼
┌─────────────────────────┐
│      NestJS Backend     │
│      TypeScript         │
└────────────┬────────────┘
             │
             │ Prisma ORM
             ▼
┌─────────────────────────┐
│      PostgreSQL         │
│        Database         │
└─────────────────────────┘
```

This architecture separates the presentation layer, business logic, and data layer.

---

# 🔒 Security

HELPHA uses authentication and authorization mechanisms to protect user data.

Security features include:

* JWT-based authentication
* Protected API routes
* User-specific medication access
* User-specific schedules
* User-specific dose history
* Input validation
* Password protection
* Authorization checks

The backend ensures that protected medication data belongs to the authenticated user.

---

# 📴 Offline Mode

Offline functionality is an important planned enhancement for HELPHA because medication reminders should remain reliable even when the device has no internet connection.

The planned offline architecture includes:

* Local medication storage
* Local schedule storage
* Local dose records
* Local notifications
* Background reminder handling
* Synchronization with the backend when connectivity is restored

Possible technologies include:

* SQLite
* Drift
* sqflite
* Flutter local notifications
* Background task scheduling

These features are planned enhancements and are not considered part of the current core implementation unless specifically implemented in the current version.

---

# 🔔 Future Reminder Enhancements

Future versions may include more advanced reminder functionality.

Planned possibilities include:

* Push notifications
* Smart snooze
* Repeat-until-confirmed reminders
* Escalating alerts for missed doses
* Custom notification sounds
* Custom vibration
* Lock-screen notifications

Possible technologies include:

* Firebase Cloud Messaging
* flutter_local_notifications
* awesome_notifications
* WorkManager

---

# 🤖 Future AI Features

AI functionality is planned as a future enhancement.

Potential features include:

* Smart medication assistance
* Medication schedule suggestions
* Medication adherence insights
* Personalized reminders
* Intelligent medication-related notifications

These features are **not considered part of the current core implementation**.

---

# 🔗 Future Integrations

Potential future integrations include:

### Drug Information

* RxNorm
* OpenFDA
* Other medication information services

### Communication

* Email verification services
* Email notification services

### Cloud Storage

* Cloud-based medication image storage
* Backup and restore functionality

### Health Platforms

* Health data integrations
* Health tracking services

These integrations can be added as the application develops.

---

# 📈 Future Health Metrics

Additional health metrics may be added in future versions.

Possible metrics include:

* Blood sugar
* Weight
* Sleep
* Other health-related measurements

These features are currently deferred and are not part of the core medication-management implementation.

---

# 🛠️ Future Infrastructure

For a production deployment, the following technologies can be considered:

| Layer              | Technology                    |
| ------------------ | ----------------------------- |
| API Hosting        | AWS ECS / Railway / Render    |
| Database Hosting   | AWS RDS / Supabase            |
| Containerization   | Docker                        |
| Push Notifications | Firebase                      |
| Queue / Cache      | Redis                         |
| Secrets Management | AWS Secrets Manager / Doppler |
| Error Monitoring   | Sentry                        |
| Logging            | Winston / Pino                |
| API Documentation  | Swagger / OpenAPI             |

These technologies represent possible future production infrastructure rather than requirements for the current local development environment.

---

# 📦 Technology Stack

| Component                 | Technology               |
| ------------------------- | ------------------------ |
| Mobile Frontend           | Flutter / Dart           |
| Backend                   | Node.js / NestJS         |
| Backend Language          | TypeScript               |
| Database                  | PostgreSQL               |
| ORM                       | Prisma                   |
| Authentication            | JWT                      |
| API                       | REST                     |
| Future Queue              | Redis / BullMQ           |
| Future Push Notifications | Firebase Cloud Messaging |
| Future Offline Database   | SQLite / Drift           |
| Future Monitoring         | Sentry                   |

---

# 🚀 Running the Project

## Prerequisites

Make sure the following are installed:

* Flutter SDK
* Dart SDK
* Node.js
* npm
* PostgreSQL
* Git

---

## 1. Clone the Repository

```bash
git clone https://github.com/rayann328/HELPHA.git
cd HELPHA
```

---

# 2. Run the Backend

Open a terminal and navigate to the backend:

```bash
cd backend
```

Install dependencies:

```bash
npm install
```

Configure the PostgreSQL database connection in the backend environment configuration.

Then start the NestJS development server:

```bash
npm run start:dev
```

The backend API will run locally according to the configured NestJS port.

---

# 3. Run the Frontend

Open another terminal:

```bash
cd frontend
```

Install Flutter dependencies:

```bash
flutter pub get
```

Check available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

---

# 🧪 Development

During development, the frontend and backend are run separately.

```text
Frontend
Flutter / Dart
      │
      │ HTTP REST API
      ▼
Backend
NestJS / TypeScript
      │
      │ Prisma
      ▼
Database
PostgreSQL
```

This development structure makes it possible to modify the mobile application and backend independently.

---

# 📌 Project Status

HELPHA currently focuses on the core medication-management workflow.

### Current Core Functionality

* Authentication
* User management
* Medication management
* Medication scheduling
* Reminders
* Dose tracking
* Calendar
* Medication history
* Profile
* Settings
* REST API communication
* PostgreSQL database integration

### Planned Enhancements

Future development may include:

* Advanced offline synchronization
* Local notification infrastructure
* Push notifications
* Smart reminder functionality
* AI-assisted medication features
* External medication information services
* Cloud backup
* Additional health metrics
* Advanced monitoring and production infrastructure

The project is structured so these features can be added without changing the overall frontend/backend architecture.

---

# 🎯 Project Goal

The goal of HELPHA is to provide a centralized medication-management solution that helps users:

* Organize their medications
* Create medication schedules
* Manage medication reminders
* Track medication doses
* Record medication activity
* Review medication history
* Monitor medication adherence
* Manage their account
* Manage application preferences

The application is designed using a modular architecture so that additional functionality can be introduced in future versions.

---

# 🌱 Future Development

HELPHA is designed with future expansion in mind.

Possible future improvements include:

1. Fully offline medication management
2. Reliable local reminder scheduling
3. Cloud synchronization
4. Advanced notification handling
5. Medication information integrations
6. AI-assisted medication management
7. Health metrics
8. Data visualization and reports
9. Cloud backup and restore
10. Production deployment infrastructure

---

# 👨‍💻 Development Team

**Project:** HELPHA

**Type:** Academic / Software Development Project

**Application:** Medication Management Mobile Application

**Frontend:** Flutter / Dart

**Backend:** Node.js / NestJS / TypeScript

**Database:** PostgreSQL

**ORM:** Prisma

---

# 📄 License

This project was developed as an academic/software development project.

The source code and project materials are intended for educational and development purposes.

---

## 📚 Summary

HELPHA combines a Flutter mobile application with a NestJS REST API and PostgreSQL database to provide a structured medication-management system.

The architecture separates the mobile interface, backend business logic, and database layer, making the application easier to maintain and extend.

The current implementation focuses on medication management, scheduling, reminders, dose tracking, calendar functionality, medication history, user accounts, and settings, while future versions can introduce offline synchronization, advanced notifications, AI features, external integrations, health metrics, and production infrastructure.
