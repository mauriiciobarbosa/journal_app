class Journal {
  Journal({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  final String id;
  final String date;
  final String mood;
  final String note;

  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
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
