class OldJournal {
  OldJournal({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  final String id;
  final String date;
  final String mood;
  final String note;

  factory OldJournal.fromJson(Map<String, dynamic> json) => OldJournal(
        id: json['id'],
        date: json['date'],
        mood: json['mood'],
        note: json['note'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'mood': mood,
        'note': note,
      };
}

class Journal {
  Journal({
    required this.documentID,
    required this.date,
    required this.mood,
    required this.note,
    required this.uid,
  });

  String documentID;
  String date;
  String mood;
  String note;
  String uid;

  factory Journal.fromDoc(dynamic doc) => Journal(
        documentID: doc.documentID,
        date: doc['date'],
        mood: doc['mood'],
        note: doc['note'],
        uid: doc['uid'],
      );

  Map<String, dynamic> toDoc() => {
        'uid': uid,
        'date': date,
        'mood': mood,
        'note': note,
      };
}
