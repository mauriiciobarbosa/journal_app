import 'package:flutter/material.dart';
import 'package:journal_app/models/journal.dart';

import 'journal_edit_bloc.dart';

class JournalEditBlocProvider extends InheritedWidget {
  const JournalEditBlocProvider(
    Key key,
    Widget child, {
    required this.journalEditBloc,
    required this.add,
    required this.journal,
  }) : super(key: key, child: child);

  final JournalEditBloc journalEditBloc;
  final bool add;
  final Journal journal;

  @override
  bool updateShouldNotify(JournalEditBlocProvider oldWidget) {
    return journalEditBloc != oldWidget.journalEditBloc;
  }

  static JournalEditBlocProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<JournalEditBlocProvider>()!;
  }
}
