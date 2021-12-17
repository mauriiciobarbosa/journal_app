import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationApi {
  FirebaseAuth getFirebaseAuth();

  Future<String> currentUserUid();

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<String> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();
}
