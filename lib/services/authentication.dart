import 'package:firebase_auth/firebase_auth.dart';
import 'package:journal_app/services/authentication_api.dart';

class AuthenticationService implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  FirebaseAuth getFirebaseAuth() => _firebaseAuth;

  @override
  Future<String> currentUserUid() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) throw Exception('user is null');

    return user.uid;
  }

  @override
  Future<String> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password
    )).user;

    if (user == null) throw Exception('user is null');

    return user.uid;
  }

  @override
  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = (await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    if (user == null) throw Exception('user is null');

    return user.uid;
  }

  @override
  Future<void> signOut() async {
    _firebaseAuth.signOut();
  }

  @override
  Future<bool> isEmailVerified() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) throw Exception('user is null');

    return user.emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) throw Exception('user is null');

    user.sendEmailVerification();
  }
}
