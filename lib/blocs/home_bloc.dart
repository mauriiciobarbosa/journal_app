import 'dart:async';

import 'package:journal_app/models/journal.dart';
import 'package:journal_app/services/authentication_api.dart';
import 'package:journal_app/services/db_firestore_api.dart';

class HomeBloc {
  final DbApi dbApi;
  final AuthenticationApi authenticationApi;

  HomeBloc({required this.dbApi, required this.authenticationApi}) {
    _startListeners();
  }

  void _startListeners() {
    final String uid =
        authenticationApi.getFirebaseAuth().currentUser?.uid ?? '';

    dbApi.getJournalList(uid).listen((journalDocs) {
      _addListJournal.add(journalDocs);
    });

    _journalDeleteController.stream.listen((journal) {
      dbApi.deleteJournal(journal);
    });
  }

  final StreamController<List<Journal>> _journalController =
      StreamController.broadcast();

  Sink<List<Journal>> get _addListJournal => _journalController.sink;

  Stream<List<Journal>> get listJournal => _journalController.stream;

  final StreamController<Journal> _journalDeleteController =
      StreamController.broadcast();

  Sink<Journal> get deleteJournal => _journalDeleteController.sink;

  void dispose() {
    _journalController.close();
    _journalDeleteController.close();
  }
}
