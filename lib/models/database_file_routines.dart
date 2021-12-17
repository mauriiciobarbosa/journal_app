import 'dart:convert';
import 'dart:io';

import 'package:journal_app/models/journal.dart';
import 'package:path_provider/path_provider.dart';

import 'database.dart';

class DatabaseFileRoutines {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/local_persistence.json');
  }

  Future<List<OldJournal>> readJournals() async {
    try {
      final file = await _localFile;

      if (!file.existsSync()) {
        print('File does not exist: ${file.absolute}');
        await writeJournals([]);
      }

      String content = await file.readAsString();
      final dataFromJson = jsonDecode(content);
      return Database.fromJson(dataFromJson).journals;
    } catch (e) {
      print('error readJournals: $e');
      return [];
    }
  }

  Future<File> writeJournals(List<OldJournal> journals) async {
    final file = await _localFile;
    final json = {
      'journals': List<dynamic>.from(
        journals.map(
          (e) => e.toJson(),
        ),
      )
    };

    return file.writeAsString(jsonEncode(json));
  }
}
