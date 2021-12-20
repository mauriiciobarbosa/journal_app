import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/services/db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const _collectionJournals = 'journals';

  @override
  Future<bool> addJournal(Journal journal) async {
    try {
      final newDoc =
          await _firestore.collection(_collectionJournals).add(journal.toDoc());

      return newDoc.id.isNotEmpty;
    } catch (error) {
      print('Error to add journal: $error');

      return false;
    }
  }

  @override
  void updateJournal(Journal journal) {
    _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .update(journal.toDoc())
        .catchError((error) => print('Error updating: $error'));
  }

  @override
  void deleteJournal(Journal journal) {
    _firestore
        .collection(_collectionJournals)
        .doc(journal.documentID)
        .delete()
        .catchError((error) => print('Error deleting: $error'));
  }

  @override
  Stream<List<Journal>> getJournalList(String uid) {
    return _firestore
        .collection(_collectionJournals)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(
      (QuerySnapshot snapshot) {
        final journalDocs =
            snapshot.docs.map((doc) => Journal.fromDoc(doc)).toList();

        journalDocs.sort((comp1, comp2) => comp2.date.compareTo(comp1.date));

        return journalDocs;
      },
    );
  }
}
