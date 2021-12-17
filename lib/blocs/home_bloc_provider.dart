import 'package:flutter/material.dart';
import 'package:journal_app/blocs/home_bloc.dart';

class HomeBlocProvider extends InheritedWidget {
  const HomeBlocProvider(
    Key key,
    Widget child, {
    required this.homeBloc,
    required this.uid,
  }) : super(key: key, child: child);

  final HomeBloc homeBloc;
  final String uid;

  @override
  bool updateShouldNotify(HomeBlocProvider oldWidget) {
    return homeBloc != oldWidget.homeBloc;
  }

  static HomeBlocProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeBlocProvider>()!;
  }
}
