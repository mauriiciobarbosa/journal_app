import 'dart:async';

import 'package:journal_app/classes/validators.dart';
import 'package:journal_app/services/authentication_api.dart';

class LoginBloc with Validators {
  LoginBloc(this.authenticationApi) {
    _startListenersIfEmailAndPasswordAreValid();
  }

  final AuthenticationApi authenticationApi;
  String _email = '';
  String _password = '';

  final StreamController<String> _emailController =
      StreamController.broadcast();

  Sink<String> get emailChanged => _emailController.sink;

  Stream<String> get email => _emailController.stream.transform(validateEmail);

  final StreamController<String> _passwordController =
      StreamController.broadcast();

  Sink<String> get passwordChanged => _passwordController.sink;

  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  final StreamController<bool> _enableLoginCreateButtonController =
      StreamController.broadcast();

  Sink<bool> get enableLoginCreateButtonChanged =>
      _enableLoginCreateButtonController.sink;

  Stream<bool> get enableLoginCreateButton =>
      _enableLoginCreateButtonController.stream;

  final StreamController<String> _loginOrCreateButtonController =
      StreamController.broadcast();

  Sink<String> get loginOrCreateButtonChanged =>
      _loginOrCreateButtonController.sink;

  Stream<String> get loginOrCreateButton =>
      _loginOrCreateButtonController.stream;

  final StreamController<String> _loginOrCreateController =
      StreamController.broadcast();

  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;

  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  void _startListenersIfEmailAndPasswordAreValid() {
    email.listen((email) {
      _email = email;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _email = '';
      _updateEnableLoginCreateButtonStream();
    });

    password.listen((password) {
      _password = password;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _password = '';
      _updateEnableLoginCreateButtonStream();
    });

    loginOrCreate.listen((action) {
      action == 'Login' ? _logIn() : _createAccount();
    });
  }

  void _updateEnableLoginCreateButtonStream() {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      enableLoginCreateButtonChanged.add(true);
    } else {
      enableLoginCreateButtonChanged.add(false);
    }
  }

  Future<String> _logIn() async {
    String result = '';

    if (_email.isEmpty || _password.isEmpty)
      return 'Email and password are not valid';

    try {
      await authenticationApi.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      result = 'Success';
    } catch (error) {
      print('Login error $error');
      result = error.toString();
    }

    return result;
  }

  Future<String> _createAccount() async {
    String result = '';

    if (_email.isEmpty || _password.isEmpty)
      return 'Email and password are not valid';

    try {
      final user = await authenticationApi.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      print('Created user $user');

      result = await _logIn();
    } catch (error) {
      print('Create account error $error');
      result = error.toString();
    }

    return result;
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _enableLoginCreateButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();
  }
}
