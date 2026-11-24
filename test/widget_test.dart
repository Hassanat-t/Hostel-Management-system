// Harness smoke tests. They check the test setup works (fakes, ScreenUtil,
// provider, Keys). They are NOT part of the 60 experiment test cases.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:newhms/features/auth/screens/login_screen.dart';
import 'package:newhms/features/home/home_screen.dart';
import 'package:newhms/services/firebase_refs.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('pumpApp shows a screen and wires the Firebase fakes',
      (tester) async {
    final env = await pumpApp(tester, const LoginScreen());

    expect(find.byKey(const Key('login_email')), findsOneWidget);
    expect(find.byKey(const Key('login_password')), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);

    expect(identical(FirebaseRefs.auth, env.auth), isTrue);
    expect(identical(FirebaseRefs.firestore, env.firestore), isTrue);
  });

  testWidgets('pumpApp puts the given user in UserProvider', (tester) async {
    final env = await pumpApp(tester, const HomeScreen(), user: testStudent);

    expect(env.provider.user?.uid, testStudent.uid);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('fake Firestore can be seeded and read', (tester) async {
    final env = await pumpApp(tester, const LoginScreen());
    await seedUser(env.firestore, testAdmin);

    final doc =
        await env.firestore.collection('users').doc(testAdmin.uid).get();
    expect(doc.exists, isTrue);
    expect(doc.get('role'), 'admin');
  });
}
