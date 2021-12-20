import 'dart:async';

import 'package:journal_app/models/journal.dart';
import 'package:journal_app/services/db_firestore_api.dart';

class JournalEditBloc {
  JournalEditBloc(this.add, this.selectedJournal, this.dbApi) {
    _startListeners().then((finished) => _getJournal(add, selectedJournal));
  }

  final DbApi dbApi;
  Journal selectedJournal;
  final bool add;

  StreamController<String> _dateController = StreamController.broadcast();

  Sink<String> get dateEditChanged => _dateController.sink;

  Stream<String> get dateEdit => _dateController.stream;

  StreamController<String> _moodController = StreamController.broadcast();

  Sink<String> get moodEditChanged => _moodController.sink;

  Stream<String> get moodEdit => _moodController.stream;

  StreamController<String> _noteController = StreamController.broadcast();

  Sink<String> get noteEditChanged => _noteController.sink;

  Stream<String> get noteEdit => _noteController.stream;

  StreamController<String> _saveJournalController =
      StreamController.broadcast();

  Sink<String> get saveJournalChanged => _saveJournalController.sink;

  Stream<String> get saveJournal => _saveJournalController.stream;

  Future<bool> _startListeners() async {
    _dateController.stream.listen((date) {
      selectedJournal.date = date;
    });

    _moodController.stream.listen((mood) {
      selectedJournal.mood = mood;
    });

    _noteController.stream.listen((note) {
      selectedJournal.note = note;
    });

    _saveJournalController.stream.listen((action) {
      if (action == 'Save') _saveJournal();
    });

    return true;
  }

  _getJournal(bool add, Journal journal) {
    if (add) {
      selectedJournal = Journal(
        documentID: '',
        mood: 'Very Satisfied',
        date: DateTime.now().toString(),
        note: '',
        uid: journal.uid,
      );
    }
    // else {
    //   selectedJournal.date = journal.date;
    //   selectedJournal.mood = journal.mood;
    //   selectedJournal.note = journal.note;
    // }

    dateEditChanged.add(selectedJournal.date);
    moodEditChanged.add(selectedJournal.mood);
    noteEditChanged.add(selectedJournal.note);
  }

  void _saveJournal() {
    Journal journal = Journal(
      documentID: selectedJournal.documentID,
      date: DateTime.parse(selectedJournal.date).toIso8601String(),
      mood: selectedJournal.mood,
      note: selectedJournal.note,
      uid: selectedJournal.uid,
    );

    add ? dbApi.addJournal(journal) : dbApi.updateJournal(journal);
  }

  void dispose() {
    _dateController.close();
    _moodController.close();
    _noteController.close();
    _saveJournalController.close();
  }
}
