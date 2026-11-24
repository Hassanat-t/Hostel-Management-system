import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// One place where the app gets its Firebase objects.
///
/// The app never sets the overrides, so it always uses the real
/// FirebaseAuth.instance and FirebaseFirestore.instance.
/// Widget tests set them to fakes (MockFirebaseAuth, FakeFirebaseFirestore)
/// through test/helpers/pump_app.dart, so no real Firebase is needed.
class FirebaseRefs {
  FirebaseRefs._();

  static FirebaseAuth? authOverride;
  static FirebaseFirestore? firestoreOverride;

  static FirebaseAuth get auth => authOverride ?? FirebaseAuth.instance;

  static FirebaseFirestore get firestore =>
      firestoreOverride ?? FirebaseFirestore.instance;

  /// Clears the overrides. Tests call this in tearDown.
  static void reset() {
    authOverride = null;
    firestoreOverride = null;
  }
}
