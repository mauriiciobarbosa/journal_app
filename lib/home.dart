import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Persistence'),
      ),
      body: SafeArea(
        child: FutureBuilder(
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
        child: Padding(padding: EdgeInsets.all(24)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _addOrEditJournal(add: true, index: -1, journal: Journal()),
        tooltip: 'Add Journal Entry',
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _localJournals() async {}

  Widget _buildListViewSeparated(AsyncSnapshot<Object?> snapshot) {
    return Center(child: Text('do nothing'));
  }

  void _addOrEditJournal({
    required bool add,
    required int index,
    required Journal journal,
  }) {
    // do something
  }
}

class Journal {}
