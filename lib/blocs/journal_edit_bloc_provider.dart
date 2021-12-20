import 'package:flutter/material.dart';
import 'package:journal_app/models/journal.dart';

import 'journal_edit_bloc.dart';

class JournalEditBlocProvider extends InheritedWidget {
  const JournalEditBlocProvider({
    required this.journalEditBloc,
    required this.add,
    required this.journal,
    required Widget child,
  }) : super(child: child);

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
