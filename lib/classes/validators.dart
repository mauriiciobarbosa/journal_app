import 'dart:async';

class Validators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isEmpty || email.contains('@') && email.contains('.')) {
      sink.add(email);
    } else if (email.length > 0) {
      sink.addError('Enter a valid email');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.isEmpty || password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Password needs to be at least 6 characters');
    }
  });
}
