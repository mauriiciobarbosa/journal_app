import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:journal_app/models/journal.dart';
import 'package:journal_app/services/db_firestore_api.dart';

class DbFirestoreService implements DbApi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List<Journal> _collectionJournals = [];

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
        .update(journal.toDoc().remove('uid'))
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
  Future<Journal> getJournal(String documentId) {
    // TODO: implement getJournal
    throw UnimplementedError();
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

  @override
  void updateJournalWithTransaction(Journal journal) {
    // TODO: implement updateJournalWithTransaction
  }
}
