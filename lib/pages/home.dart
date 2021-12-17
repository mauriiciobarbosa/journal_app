import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/models/database.dart';
import 'package:journal_app/models/database_file_routines.dart';
import 'package:journal_app/models/journal_edit.dart';
import 'package:journal_app/pages/edit_entry.dart';

import '../models/journal.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _databaseFileRoutines = DatabaseFileRoutines();
  late Database _database;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Journal',
          style: TextStyle(
            color: Colors.lightGreen.shade800,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(32),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO add a method to sign out the current user
            },
            icon: Icon(Icons.exit_to_app),
            color: Colors.lightGreen.shade800,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<OldJournal>>(
          initialData: [],
          future: _localJournals(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? _buildListViewSeparated(snapshot)
                : Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen.shade200, Colors.lightGreen],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditJournal(
          context: context,
          add: true,
          index: -1,
          journal: OldJournal(
            date: '',
            id: '',
            mood: '',
            note: '',
          ),
        ),
        tooltip: 'Add Journal Entry',
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen.shade300,
      ),
    );
  }

  Future<List<OldJournal>> _localJournals() async {
    final journals = await _databaseFileRoutines.readJournals();

    journals.sort((j1, j2) => j2.date.compareTo(j1.date));

    _database = Database(journals: journals);

    return _database.journals;
  }

  Widget _buildListViewSeparated(AsyncSnapshot<List<OldJournal>> snapshot) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final journal = snapshot.data![index];
        final date = DateTime.parse(journal.date);
        return Dismissible(
          key: Key(journal.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            setState(() {
              _database.journals.removeAt(index);
            });
            _databaseFileRoutines.writeJournals(_database.journals);
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Column(
              children: [
                Text(
                  DateFormat.d().format(date),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${DateFormat.E().format(date)}')
              ],
            ),
            title: Text(
              '${DateFormat('MMM dd, y').format(date)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${journal.mood}\n${journal.note}'),
            onTap: () => _addOrEditJournal(
              context: context,
              add: false,
              index: index,
              journal: journal,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey,
      ),
      itemCount: snapshot.data!.length,
    );
  }

  void _addOrEditJournal({
    required BuildContext context,
    required bool add,
    required int index,
    required OldJournal journal,
  }) async {
    final journalEdit = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditEntry(
          add: add,
          index: index,
          journal: journal,
        ),
        fullscreenDialog: true,
      ),
    );

    if (journalEdit is JournalEdit && journalEdit.action == 'Save') {
      if (add) {
        setState(() {
          _database.journals.add(journalEdit.journal);
        });
      } else {
        setState(() {
          _database.journals[index] = journalEdit.journal;
        });
      }
      _databaseFileRoutines.writeJournals(_database.journals);
    }
  }
}
