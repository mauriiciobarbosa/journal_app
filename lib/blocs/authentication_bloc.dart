import 'dart:async';

import 'package:journal_app/services/authentication_api.dart';

class AuthenticationBloc {
  final AuthenticationApi authenticationApi;
  final StreamController<String> _authenticationController = StreamController();
  final StreamController<bool> _logoutController = StreamController();

  Sink<String> get addUser => _authenticationController.sink;

  Stream<String> get user => _authenticationController.stream;

  Sink<bool> get logoutUser => _logoutController.sink;

  Stream<bool> get listLogoutUser => _logoutController.stream;

  AuthenticationBloc({required this.authenticationApi}) {
    onAuthChanged();
  }

  void onAuthChanged() {
    authenticationApi.getFirebaseAuth().authStateChanges().listen((user) {
      final uid = user?.uid ?? '';
      addUser.add(uid);
    });

    _logoutController.stream.listen((logout) {
      if (logout) _signOut();
    });
  }

  void _signOut() {
    authenticationApi.signOut();
  }

  void dispose() {
    _authenticationController.close();
    _logoutController.close();
  }
}
