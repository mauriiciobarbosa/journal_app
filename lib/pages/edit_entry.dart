import 'package:flutter/material.dart';
import 'package:journal_app/blocs/journal_edit_bloc.dart';
import 'package:journal_app/blocs/journal_edit_bloc_provider.dart';
import 'package:journal_app/classes/format_dates.dart';
import 'package:journal_app/classes/mood_icons.dart';

class EditEntry extends StatefulWidget {
  EditEntry();

  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  late JournalEditBloc _journalEditBloc;
  late FormatDates _formatDates;
  late List<MoodIcons> _moodIcons;
  late String _title;

  final TextEditingController _moodController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _formatDates = FormatDates();
    _moodIcons = moodIconsList;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _journalEditBloc = JournalEditBlocProvider.of(context).journalEditBloc;

    _title = _journalEditBloc.add ? 'Add' : 'Edit';

    if (_journalEditBloc.add) {
      _moodController.text = '';
      _noteController.text = '';
    } else {
      _moodController.text = _journalEditBloc.selectedJournal.mood;
      _noteController.text = _journalEditBloc.selectedJournal.note;
    }
  }

  @override
  void dispose() {
    _moodController.dispose();
    _noteController.dispose();
    _journalEditBloc.dispose();

    super.dispose();
  }

  Future<DateTime> _selectDate(DateTime selectedDate) async {
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    return _pickedDate ?? selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$_title Entry',
          style: TextStyle(color: Colors.lightGreen.shade800),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<String>(
                stream: _journalEditBloc.dateEdit,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return !snapshot.hasData
                      ? Container()
                      : _buildDateWidget(context, snapshot);
                },
              ),
              StreamBuilder<String>(
                stream: _journalEditBloc.moodEdit,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return !snapshot.hasData
                      ? Container()
                      : _buildMoodWidget(snapshot);
                },
              ),
              StreamBuilder<String>(
                stream: _journalEditBloc.noteEdit,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return !snapshot.hasData
                      ? Container()
                      : _buildNoteWidget(snapshot);
                },
              ),
              _buildActionWidgets(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateWidget(
      BuildContext context, AsyncSnapshot<String> snapshot) {
    return TextButton(
      onPressed: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final pickerDate = await _selectDate(
          DateTime.parse(snapshot.requireData),
        );
        _journalEditBloc.dateEditChanged.add(
          pickerDate.toString(),
        );
      },
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 24,
            color: Colors.black54,
          ),
          SizedBox(width: 16),
          Text(
            _formatDates.dateFormatLongMonthDayYear(snapshot.requireData),
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: Colors.black54,
          )
        ],
      ),
    );
  }

  DropdownButtonHideUnderline _buildMoodWidget(AsyncSnapshot<String> snapshot) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<MoodIcons>(
        value: moodIconsList.firstWhere((icon) => icon.title == snapshot.data),
        onChanged: (selected) {
          if (selected != null)
            _journalEditBloc.moodEditChanged.add(selected.title);
        },
        items: _moodIcons.map((selected) {
          return DropdownMenuItem<MoodIcons>(
            value: selected,
            child: Row(
              children: [
                Transform(
                  transform: Matrix4.identity()
                    ..rotateZ(
                      getMoodRotation(selected.title),
                    ),
                  alignment: Alignment.center,
                  child: Icon(
                    getMoodIcon(selected.title),
                    color: getMoodColor(
                      selected.title,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Text(selected.title),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNoteWidget(AsyncSnapshot<String> snapshot) {
    return TextField(
      controller: _noteController,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
      maxLines: null,
      decoration: InputDecoration(
        labelText: 'Note',
        icon: Icon(Icons.subject),
      ),
      onChanged: (text) {
        _journalEditBloc.noteEditChanged.add(text);
      },
    );
  }

  Row _buildActionWidgets(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
          ),
        ),
        SizedBox(width: 8),
        TextButton(
          onPressed: () {
            _journalEditBloc.saveJournalChanged.add('Save');
            // _journalEdit.action = 'Save';
            //
            // final id = widget.add
            //     ? Random().nextInt(9999999).toString()
            //     : _journalEdit.journal.uid;
            // final newJournal = Journal(
            //   documentID: '',
            //   date: _selectedDate.toString(),
            //   mood: _moodController.text,
            //   note: _noteController.text,
            //   uid: id,
            // );
            // _journalEdit.journal = newJournal;

            Navigator.of(context).pop();
          },
          child: Text(
            'Save',
            style: TextStyle(color: Colors.grey.shade100),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.lightGreen,
            ),
          ),
        ),
      ],
    );
  }
}
