part of '../getxfire.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createData({
    required String collection,
    required Map<String, dynamic> data,
    String? id,
  }) async {
    try {
      if (id == null)
        return await _firestore
            .collection(collection)
            .add(data)
            .then((value) => true)
            .catchError((error) {
          GetxFire.openDialog.messageError(error.toString());
          return false;
        });
      else
        return await _firestore
            .collection(collection)
            .doc(id)
            .set(data)
            .then((value) => true)
            .catchError((error) {
          GetxFire.openDialog.messageError(error.toString());
          return false;
        });
    } catch (e) {
      GetxFire.openDialog.messageError(e.toString());
      return false;
    }
  }

  Future<bool> updateData({
    required String collection,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _firestore
          .collection(collection)
          .doc(id)
          .update(data)
          .then((value) => true)
          .catchError((error) {
        GetxFire.openDialog.messageError(error.toString());
        return false;
      });
    } catch (e) {
      GetxFire.openDialog.messageError(e.toString());
      return false;
    }
  }

  Future<List<QueryDocumentSnapshot<Object?>?>?> getData(
      {required String collection, String? ownerUID}) async {
    try {
      Query _query = _firestore.collection(collection);

      if (ownerUID != null)
        _query = _query.where("ownerUID", isEqualTo: ownerUID);

      QuerySnapshot _doc = await _query
          .orderBy("createdAt", descending: true)
          .get()
          .catchError((error) {
        GetxFire.openDialog.messageError(error.toString());
        // return null;
      });
      return _doc.docs;
    } catch (e) {
      GetxFire.openDialog.messageError(e.toString());
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot?>?> searchData({
    required String collection,
    String? ownerUID,
    required String search,
  }) async {
    try {
      Query _query = _firestore.collection(collection);

      if (ownerUID != null)
        _query = _query.where("ownerUID", isEqualTo: ownerUID);

      _query = _query.where('searchIndex',
          arrayContains: search.toLowerCase().trim());

      QuerySnapshot _doc = await _query
          .orderBy("createdAt", descending: true)
          .get()
          .catchError((error) {
        GetxFire.openDialog.messageError(error.toString());
        // return null;
      });
      return _doc.docs;
    } catch (e) {
      GetxFire.openDialog.messageError(e.toString());
      rethrow;
    }
  }

  Future<DocumentSnapshot?> getDetail({
    required String collection,
    required String id,
  }) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(collection)
          .doc(id)
          .get()
          .catchError((error) {
        GetxFire.openDialog.messageError(error.toString());
        // return null;
      });
      return doc;
    } catch (e) {
      GetxFire.openDialog.messageError(e.toString());
      rethrow;
    }
  }

  Future<void> deleteData({
    required String collection,
    required String id,
    FileModel? photo,
  }) async {
    try {
      return await _firestore
          .collection(collection)
          .doc(id)
          .delete()
          .then((_) async {
        if (photo != null)
          await StorageService().deleteFile(photo.filename!,
              fileType: photo.type!, folder: photo.folder!);
      }).catchError((error) {
        GetxFire.openDialog.messageError(error.toString());
        return null;
      });
    } catch (e) {
      GetxFire.openDialog.messageError(e.toString());
      rethrow;
    }
  }

  Stream<QuerySnapshot> streamData({
    required String collection,
    String? collectionChild,
    String? idChild,
  }) {
    if (collectionChild == null && idChild == null)
      return _firestore
          .collection(collection)
          // .orderBy("dateCreated", descending: true)
          .snapshots();
    else
      return _firestore
          .collection(collection)
          .doc(idChild)
          .collection(collectionChild!)
          // .orderBy("dateCreated", descending: true)
          .snapshots();
  }

  Stream<DocumentSnapshot> streamDetail({
    required String collection,
    String? collectionChild,
    required String id,
    String? idChild,
    Map<String, dynamic>? data,
  }) {
    if (collectionChild == null)
      return _firestore
          // .doc(uid)
          .collection(collection)
          .doc(id)
          // .orderBy("dateCreated", descending: true)
          .snapshots();
    else
      return _firestore
          .collection(collection)
          .doc(id)
          .collection(collectionChild)
          .doc(idChild)
          // .orderBy("dateCreated", descending: true)
          .snapshots();
  }
}
