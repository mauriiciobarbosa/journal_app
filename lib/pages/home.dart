import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:journal_app/blocs/authentication_bloc.dart';
import 'package:journal_app/blocs/authentication_bloc_provider.dart';
import 'package:journal_app/blocs/home_bloc.dart';
import 'package:journal_app/blocs/home_bloc_provider.dart';
import 'package:journal_app/blocs/journal_edit_bloc.dart';
import 'package:journal_app/blocs/journal_edit_bloc_provider.dart';
import 'package:journal_app/classes/format_dates.dart';
import 'package:journal_app/classes/mood_icons.dart';
import 'package:journal_app/pages/edit_entry.dart';
import 'package:journal_app/services/db_firestore.dart';

import '../models/journal.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AuthenticationBloc _authenticationBloc;
  late HomeBloc _homeBloc;
  late String _uid;
  final FormatDates _formatDates = FormatDates();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
  }

  @override
  void dispose() {
    // _homeBloc.dispose();

    super.dispose();
  }

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
              _authenticationBloc.logoutUser.add(true);
            },
            icon: Icon(Icons.exit_to_app),
            color: Colors.lightGreen.shade800,
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<Journal>>(
          initialData: [],
          stream: _homeBloc.listJournal,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot);
            } else {
              return Center(child: Text('Add Journals.'));
            }
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
          add: true,
          journal: Journal(
            documentID: '',
            date: '',
            mood: '',
            note: '',
            uid: _uid,
          ),
        ),
        tooltip: 'Add Journal Entry',
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen.shade300,
      ),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot<List<Journal>> snapshot) {
    return ListView.separated(
      itemCount: snapshot.data!.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey),
      itemBuilder: (context, index) {
        final journal = snapshot.data![index];
        return Dismissible(
          key: Key(journal.documentID),
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
          confirmDismiss: (_) async {
            final confirmDelete = await _confirmDeleteJournal();

            if (confirmDelete) _homeBloc.deleteJournal.add(journal);
          },
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Column(
              children: [
                Text(
                  _formatDates.dateFormatDayNumber(journal.date),
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(_formatDates.dateFormatDayName(journal.date))
              ],
            ),
            trailing: Transform(
              transform: Matrix4.identity()
                ..rotateZ(getMoodRotation(journal.mood)),
              alignment: Alignment.center,
              child: Icon(
                getMoodIcon(journal.mood),
                color: getMoodColor(journal.mood),
                size: 42,
              ),
            ),
            title: Text(
              _formatDates.dateFormatShortMonthDayYear(journal.date),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${journal.mood}\n${journal.note}'),
            onTap: () => _addOrEditJournal(
              add: false,
              journal: journal,
            ),
          ),
        );
      },
    );
  }

  void _addOrEditJournal({
    required bool add,
    required Journal journal,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JournalEditBlocProvider(
          journal: journal,
          journalEditBloc: JournalEditBloc(
            add,
            journal,
            DbFirestoreService(),
          ),
          add: add,
          child: EditEntry(),
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<bool> _confirmDeleteJournal() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Journal'),
          content: Text('Are you sure you would like to Delete?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
