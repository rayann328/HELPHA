# 💊 HELPHA — Medication Management Application

HELPHA is a medication management mobile application designed to help users organize their medications, create medication schedules, manage reminders, track medication doses, and review medication history.

The project uses a separate **Flutter frontend**, **NestJS backend**, and **PostgreSQL database**, connected through a REST API.

---

## 📱 Frontend

### Technologies

* Flutter
* Dart

Flutter provides a single codebase for the mobile application.

### Frontend Responsibilities

The Flutter application handles:

* User interface
* Application navigation
* Authentication
* Medication management
* Medication scheduling
* Reminders
* Calendar
* Medication history
* Profile
* Settings
* Communication with the backend API

### Frontend Structure

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

### Technologies

* Node.js
* NestJS
* TypeScript
* REST API
* JWT Authentication
* Prisma ORM

The backend follows a modular architecture where different application responsibilities are separated into independent modules.

### Main Backend Modules

* Authentication
* Users
* Medications
* Schedules
* Reminders
* History
* Profile
* Settings
* Notifications
* Reports
* Storage
* Sync

### Backend Responsibilities

The backend handles:

* User authentication
* User management
* Medication data
* Medication schedules
* Dose logs
* Reminder data
* Medication history
* Request validation
* Authorization
* Database communication

---

# 🗄️ Database

### Database

PostgreSQL

### ORM

Prisma

The database uses a relational structure to connect users, medications, schedules, and medication dose records.

### Main Database Models

* User
* Medication
* Schedule
* DoseLog
* Notification
* NotificationPreferences
* UserSettings

### Main Relationship

```text
User
 │
 ├── Medications
 │      │
 │      └── Schedules
 │
 └── Dose Logs
```

This structure allows HELPHA to associate medication schedules and dose records with the correct user.

---

# 🔌 API Communication

The Flutter application communicates with the NestJS backend through REST API endpoints.

### Main API Areas

```text
/auth
/users
/medications
/schedules
/reminders
/history
```

Protected endpoints require authentication.

The backend validates requests and ensures that users can access only the data associated with their authenticated account.

---

# 🔐 Authentication & Security

HELPHA uses authentication and authorization mechanisms to protect user accounts and medication data.

Security features include:

* User registration
* User login
* JWT-based authentication
* Protected API routes
* User-specific medication access
* User-specific schedules
* User-specific dose history
* Input validation
* Password protection
* Authorization checks

---

# 💊 Medication Management

HELPHA provides functionality for managing medications.

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

HELPHA provides a scheduling system for organizing medication doses.

Supported schedule types include:

* Daily
* Weekly
* Monthly
* Custom recurring schedules
* Interval-based schedules
* One-time schedules

Schedules can contain information such as:

* Start date
* End date
* Time of day
* Days of the week
* Day of the month
* Repeating interval
* Timing information

The backend generates and maintains medication dose records based on the configured schedules.

---

# 🔔 Reminders

HELPHA includes a reminder system for managing upcoming and scheduled medication doses.

Current reminder functionality includes:

* Upcoming reminders
* Today's reminders
* Reminder details
* Dose status management
* Marking a dose as taken
* Skipping a dose
* Delaying a dose
* Marking a dose as missed
* Pending doses

### Dose Statuses

```text
PENDING
TAKEN
SKIPPED
DELAYED
MISSED
```

---

# 📊 Dose Tracking

HELPHA records individual medication doses.

A dose can be recorded as:

* Taken
* Skipped
* Delayed
* Missed
* Pending

Dose records can contain:

* Medication
* Schedule
* Scheduled date and time
* Dose status
* Taken date and time
* Notes

This information is used to maintain the user's medication activity and history.

---

# 📖 Medication History

The History section provides a record of medication dose activity.

History information can be associated with:

* Medication
* Schedule
* Dose
* Status
* Date and time
* Notes

This allows users to review previous medication activity.

---

# 📆 Calendar

HELPHA includes a calendar section for viewing medication-related schedules and activity by date.

The calendar helps users view:

* Scheduled medications
* Upcoming doses
* Completed doses
* Missed doses
* Medication activity by date

---

# 🏠 Dashboard

The Home Dashboard provides an overview of the user's medication activity.

It provides access to important medication information such as:

* Today's medications
* Upcoming medication
* Medication reminders
* Medication schedules
* Medication completion information
* Quick access to medication management

---

# 👤 Profile

The Profile section allows users to manage their account information.

Profile functionality includes:

* Viewing profile information
* Editing personal information
* Managing account information
* Accessing application settings

---

# ⚙️ Settings

The Settings section provides options for managing application preferences and account-related settings.

Settings include areas related to:

* Notifications
* Security
* Account preferences
* Application preferences

---

# 📱 Main Application Screens

The main HELPHA application workflow includes:

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

HELPHA follows a separated frontend and backend architecture.

```text
┌─────────────────────────────┐
│      Flutter Mobile App     │
│          Dart               │
└──────────────┬──────────────┘
               │
               │ REST API
               ▼
┌─────────────────────────────┐
│       NestJS Backend        │
│        TypeScript           │
└──────────────┬──────────────┘
               │
               │ Prisma ORM
               ▼
┌─────────────────────────────┐
│       PostgreSQL            │
│         Database            │
└─────────────────────────────┘
```

This separation allows the frontend, backend, and database layers to be developed and maintained independently.

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

## 2. Run the Backend

Open a terminal and navigate to the backend:

```bash
cd backend
```

Install dependencies:

```bash
npm install
```

Configure the PostgreSQL database connection using the backend environment configuration.

Then start the NestJS development server:

```bash
npm run start:dev
```

The backend runs locally using the configured NestJS port.

---

## 3. Run the Frontend

Open another terminal and navigate to the frontend:

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
Flutter Mobile Application
            │
            │ REST API
            ▼
      NestJS Backend
            │
            │ Prisma ORM
            ▼
      PostgreSQL Database
```

This structure allows each part of the system to be developed and maintained independently.

---

# 📴 Offline Mode

Reliable offline functionality is an important future enhancement for HELPHA because medication management and reminders should remain dependable even when there is no internet connection.

Planned offline capabilities include:

* Local medication storage
* Local schedule storage
* Local dose records
* Local notifications
* Background reminder handling
* Synchronization with the backend when connectivity is restored

Possible technologies for future development include:

* SQLite
* Drift
* sqflite
* Flutter local notifications
* Background task scheduling

These features are considered future enhancements and are not presented as part of the current core implementation.

---

# 🔔 Future Reminder Enhancements

Future versions of HELPHA may introduce more advanced reminder functionality, including:

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

AI functionality may be introduced in future versions.

Potential features include:

* Smart medication assistance
* Medication schedule suggestions
* Medication adherence insights
* Personalized reminders
* Intelligent medication-related notifications

AI functionality is **not part of the current core implementation**.

---

# 🔗 Future Integrations

Future versions may integrate with external services such as:

* Drug information services
* RxNorm
* OpenFDA
* Email verification services
* Cloud storage services
* Health data platforms

These integrations are planned for future development.

---

# 📈 Future Health Metrics

Additional health tracking functionality may be added in future versions.

Possible metrics include:

* Blood sugar
* Weight
* Sleep
* Other health-related measurements

These features are currently deferred.

---

# 🛠️ Future Production Infrastructure

For future production deployment, HELPHA may use technologies such as:

| Layer              | Possible Technology           |
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

These technologies represent possible future production infrastructure and are not required for the current local development setup.

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

# 📌 Project Status

HELPHA currently focuses on the core medication-management workflow.

### Current Core Areas

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

### Future Enhancements

The following areas are planned for future versions:

* Advanced offline synchronization
* Local notification infrastructure
* Push notifications
* Smart reminder functionality
* AI-assisted medication features
* External medication information services
* Cloud backup and synchronization
* Additional health metrics
* Advanced monitoring
* Production deployment infrastructure

---

# 🎯 Project Goal

The goal of HELPHA is to provide a centralized medication-management solution that helps users:

* Organize their medications
* Create medication schedules
* Manage medication reminders
* Track medication doses
* Review medication history
* Monitor medication adherence
* Manage their account
* Manage application preferences

The application uses a modular architecture so that additional functionality can be introduced in future versions without changing the overall structure of the system.

---

# 🌱 Future Development

HELPHA is designed to support future expansion.

Potential future improvements include:

1. Fully offline medication management
2. Reliable local reminder scheduling
3. Cloud synchronization
4. Advanced notification handling
5. Medication information integrations
6. AI-assisted medication management
7. Health metrics
8. Data visualization and reports
9. Cloud backup and restore
10. Production deployment

---

# 👨‍💻 Project Information

**Project:** HELPHA

**Type:** Academic / Software Development Project

**Application:** Medication Management Mobile Application

**Frontend:** Flutter / Dart

**Backend:** Node.js / NestJS / TypeScript

**Database:** PostgreSQL

**ORM:** Prisma

**API:** REST

**Authentication:** JWT

---

# 📄 License

This project was developed as an academic/software development project.

The source code and project materials are intended for educational and development purposes.
