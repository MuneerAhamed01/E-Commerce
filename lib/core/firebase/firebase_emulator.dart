import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Whether Firebase emulators should be used.
bool get useFirebaseEmulators =>
    const bool.fromEnvironment('USE_FIREBASE_EMULATORS');

/// Connects Firebase Auth and Firestore to local emulators in debug mode.
Future<void> connectFirebaseEmulatorsIfNeeded() async {
  if (!kDebugMode || !useFirebaseEmulators) return;

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
