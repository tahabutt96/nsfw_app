import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a collection reference
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  // Get a document reference
  DocumentReference<Map<String, dynamic>> document(String path) {
    return _firestore.doc(path);
  }

  // CREATE - Add a new document with auto-generated ID
  Future<DocumentReference<Map<String, dynamic>>> add(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    final docRef = await _firestore.collection(collectionPath).add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return docRef;
  }

  // CREATE - Set a document with specific ID
  Future<void> set(
    String documentPath,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    await _firestore.doc(documentPath).set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: merge));
  }

  // READ - Get a single document
  Future<DocumentSnapshot<Map<String, dynamic>>> get(String documentPath) async {
    return await _firestore.doc(documentPath).get();
  }

  // READ - Get all documents in a collection
  Future<QuerySnapshot<Map<String, dynamic>>> getAll(
    String collectionPath, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)? queryBuilder,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return await query.get();
  }

  // READ - Stream a single document
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument(String documentPath) {
    return _firestore.doc(documentPath).snapshots();
  }

  // READ - Stream a collection
  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(
    String collectionPath, {
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)? queryBuilder,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }

  // UPDATE - Update specific fields in a document
  Future<void> update(
    String documentPath,
    Map<String, dynamic> data,
  ) async {
    await _firestore.doc(documentPath).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // DELETE - Delete a document
  Future<void> delete(String documentPath) async {
    await _firestore.doc(documentPath).delete();
  }

  // BATCH - Perform batch operations
  WriteBatch batch() {
    return _firestore.batch();
  }

  // TRANSACTION - Perform transaction operations
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction) transactionHandler,
  ) async {
    return await _firestore.runTransaction(transactionHandler);
  }
}
