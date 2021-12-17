import 'journal.dart';

class Database {
  Database({required this.journals});

  List<OldJournal> journals;

  factory Database.fromJson(Map<String, dynamic> json) {
    return Database(
      journals: List<OldJournal>.from(
        json['journals'].map(
          (x) => OldJournal.fromJson(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'journals': List<dynamic>.from(
        journals.map(
          (e) => e.toJson(),
        ),
      ),
    };
  }
}
