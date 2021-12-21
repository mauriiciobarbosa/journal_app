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

  factory Journal.fromDoc(dynamic doc) {
    return Journal(
      documentID: doc.id,
      date: doc['date'],
      mood: doc['mood'],
      note: doc['note'],
      uid: doc['uid'],
    );
  }

  Map<String, dynamic> toDoc() => {
        'uid': uid,
        'date': date,
        'mood': mood,
        'note': note,
      };
}
