import 'journal.dart';

class Database {
  Database({required this.journals});

  List<Journal> journals;

  factory Database.fromJson(Map<String, dynamic> json) {
    return Database(
      journals: List<Journal>.from(
        json['journals'].map(
          (x) => Journal.fromJson(x),
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
