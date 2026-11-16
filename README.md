# Hostel Management System (HMS)

A cross-platform mobile app for managing student hostels, built with **Flutter** and **Firebase**.
Final-year project, BSc Computer Science, Crescent University, Abeokuta, Nigeria.

Students can register into a hostel block and room, check room availability and report maintenance issues. Staff and administrators can manage issues, staff accounts and room change requests. What each user can see depends on their role.

<!-- Screenshots coming soon: login, dashboard, room availability, raise issue -->

## Features

### Authentication and roles
- Email and password sign-up and login with **Firebase Authentication**
- User profiles stored in **Cloud Firestore**
- **Role-based access control** for three roles: `student`, `staff` and `admin`. Restricted features show "You do not have access to this feature"
- An auth gate sends users to the login screen or the dashboard based on their session

### For students
- **Registration** with block and room selection (Bowlsant 1: rooms B1-01 to B1-33; Bowlsant 2: rooms B2-01 to B2-30)
- **Dashboard** showing the student's name, block and room
- **Room availability**: capacity, current occupancy, room type and an Available/Unavailable status
- **Raise an issue**: submit a maintenance issue with room, block, contact details and a comment
- **Change room**: request a move to another block and room, with a reason
- **Profile**: view and update username, name and phone number

### For staff and admins
- **All issues**: view reported issues and mark them as resolved
- **Staff members**: view and delete staff accounts
- **Create staff** (admin only): create staff accounts with a job role
- **Room change requests**: review student requests and approve or reject them

## Tech stack

| Area | Technology |
|---|---|
| Framework | Flutter (Dart SDK ^3.5) |
| Backend | Firebase Authentication, Cloud Firestore, Firebase Storage |
| State management | Provider |
| UI | flutter_screenutil, google_fonts, flutter_svg |
| Charts | fl_chart, syncfusion_flutter_charts |

## Project structure

```
lib/
├── authgate.dart            # Sends users to Login or Dashboard
├── main.dart
├── common/                  # Shared app bar, constants, spacing
├── features/
│   ├── auth/                # Login, registration, form widgets
│   ├── home/                # Dashboard with role-based categories
│   ├── student/             # Room availability, raise issue, change room, profile, hostel fee
│   └── admin/               # Issues, staff list, create staff, room change requests
├── models/                  # UserModel, IssueModel
├── providers/               # UserProvider (logged-in user state)
└── theme/                   # Colours and text styles
```

## Getting started

**Prerequisites:** the Flutter SDK (3.5 or later) and a Firebase project.

```bash
git clone https://github.com/Hassanat-t/Hostel-Management-system.git
cd Hostel-Management-system
flutter pub get

# Connect your own Firebase project (generates lib/firebase_options.dart)
dart pub global activate flutterfire_cli
flutterfire configure

flutter run
```

In the Firebase console, enable **Email/Password** sign-in and create a **Cloud Firestore** database. The app uses the `users` and `issues` collections.

## Status and roadmap

The core flows (authentication, roles, registration, raising and resolving issues, profile updates and staff creation) are working. Still in progress:

- [ ] **Hostel fee** screen (currently a placeholder)
- [ ] **Room availability** reads from Firestore (currently uses sample data)
- [ ] **Room change approval** saves its decision to Firestore (currently simulated)
- [ ] **Change room** screen shows the student's real current room
- [ ] **Automated tests** for the main user flows

## Author

**Hassanat Anidu**, Flutter and full-stack developer
[GitHub](https://github.com/Hassanat-t) · taiwoanidu8@gmail.com
