// Shared test helper for the Hostel Management System.
//
// Every widget test (hand-written or LLM-generated) uses pumpApp() to show a
// screen with fake Firebase, ScreenUtil and a UserProvider already set up.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:newhms/models/user_model.dart';
import 'package:newhms/providers/user_provider.dart';
import 'package:newhms/services/firebase_refs.dart';

/// What pumpApp gives back, so a test can seed data or check what was saved.
class TestEnv {
  TestEnv(this.auth, this.firestore, this.provider);

  final MockFirebaseAuth auth;
  final FakeFirebaseFirestore firestore;
  final UserProvider provider;
}

/// Shows [screen] inside MaterialApp + ScreenUtilInit + UserProvider.
///
/// - [user]: put this user in the UserProvider (the logged-in user).
/// - [auth]: a MockFirebaseAuth to use. Default: a new signed-out one.
/// - [firestore]: a FakeFirebaseFirestore to use. Default: a new empty one.
///   Seed data into it BEFORE calling pumpApp if the screen loads data
///   when it opens.
///
/// The screen is a phone-sized 375 x 825 surface, so widgets low on a long
/// form may be off screen: call `await tester.ensureVisible(finder)` before
/// tapping them.
///
/// pumpApp ends with one `tester.pump()`. After a tap that starts async work
/// (Firebase calls, SnackBars), call `await tester.pumpAndSettle()`.
Future<TestEnv> pumpApp(
  WidgetTester tester,
  Widget screen, {
  UserModel? user,
  MockFirebaseAuth? auth,
  FakeFirebaseFirestore? firestore,
}) async {
  tester.view.physicalSize = const Size(375 * 3, 825 * 3);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);

  final fakeAuth = auth ?? MockFirebaseAuth();
  final fakeFirestore = firestore ?? FakeFirebaseFirestore();
  FirebaseRefs.authOverride = fakeAuth;
  FirebaseRefs.firestoreOverride = fakeFirestore;
  addTearDown(FirebaseRefs.reset);

  final provider = UserProvider();
  if (user != null) provider.setUser(user);

  await tester.pumpWidget(
    ChangeNotifierProvider<UserProvider>.value(
      value: provider,
      child: ScreenUtilInit(
        designSize: const Size(375, 825),
        child: MaterialApp(home: screen),
      ),
    ),
  );
  await tester.pump();

  return TestEnv(fakeAuth, fakeFirestore, provider);
}

/// Saves [user] in the fake 'users' collection, the way the app stores users.
/// Adds a 'createdAt' field because the Staff Members screen orders by it.
Future<void> seedUser(FakeFirebaseFirestore firestore, UserModel user) {
  return firestore.collection('users').doc(user.uid).set({
    ...user.toMap(),
    'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
  });
}

/// A MockFirebaseAuth whose sign-in returns an account with this uid/email.
MockFirebaseAuth authFor(UserModel user, {bool signedIn = false}) {
  return MockFirebaseAuth(
    signedIn: signedIn,
    mockUser: MockUser(uid: user.uid, email: user.email),
  );
}

// Ready-made users. Roles are lowercase, as stored by the app.

final testStudent = UserModel(
  uid: 'student-1',
  email: 'ada@student.com',
  firstName: 'Ada',
  lastName: 'Okafor',
  username: 'ada_o',
  role: 'student',
  isActive: true,
  block: 'Bowlsant1',
  room: 'B1-05',
  phoneNumber: '08012345678',
);

final testStaff = UserModel(
  uid: 'staff-1',
  email: 'jane@hostel.com',
  firstName: 'Jane',
  lastName: 'Bello',
  username: 'jane_b',
  role: 'staff',
  isActive: true,
  phoneNumber: '08087654321',
);

final testAdmin = UserModel(
  uid: 'admin-1',
  email: 'admin@hostel.com',
  firstName: 'Sam',
  lastName: 'Adeyemi',
  username: 'admin',
  role: 'admin',
  isActive: true,
  phoneNumber: '08000000000',
);
