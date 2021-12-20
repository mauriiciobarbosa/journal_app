import 'package:flutter/material.dart';

import 'authentication_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  const AuthenticationBlocProvider({
    required Widget child,
    required this.authenticationBloc,
  }) : super(child: child);

  final AuthenticationBloc authenticationBloc;

  @override
  bool updateShouldNotify(AuthenticationBlocProvider oldWidget) {
    return authenticationBloc != oldWidget.authenticationBloc;
  }

  static AuthenticationBlocProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>()!;
  }
}
