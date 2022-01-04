part of '../getxfire.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> createData({
    required String collection,
    required Map<String, dynamic> data,
    String? id,
    bool isErrorDialog = true,
    Function(String? message)? onError,
  }) async {
    // try {
    if (id == null) {
      return await _firestore
          .collection(collection)
          .add(data)
          .then((value) => true)
          .catchError((error) async {
        if (isErrorDialog) {
          GetxFire.openDialog.messageError(error.toString());
        } else {
          await GetxFire.hideProgressHud();
        }
        if (onError != null) onError(error);
        return false;
      });
    } else {
      return await _firestore
          .collection(collection)
          .doc(id)
          .set(data)
          .then((value) => true)
          .catchError((error) async {
        if (isErrorDialog) {
          GetxFire.openDialog.messageError(error.toString());
        } else {
          await GetxFire.hideProgressHud();
        }
        if (onError != null) onError(error);
        return false;
      });
    }
    // } catch (e) {
    //   GetxFire.openDialog.messageError(e.toString());
    //   return false;
    // }
  }

  Future<bool> updateData({
    required String collection,
    required String? id,
    required Map<String, dynamic> data,
    bool isErrorDialog = true,
    void Function(FirebaseException firebaseException)? onError,
  }) async {
    // try {
    return await _firestore
        .collection(collection)
        .doc(id)
        .update(data)
        .then((value) => true)
        .catchError((error) async {
      if (isErrorDialog) {
        GetxFire.openDialog.messageError(error.message.toString(),
            title: error.code.toString());
      } else {
        await GetxFire.hideProgressHud();
      }
      if (onError != null) onError(error);
      return false;
    });
    // } catch (e) {
    //   GetxFire.openDialog.messageError(e.toString());
    //   return false;
    // }
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getData({
    required String collection,
    String? ownerUID,
    bool isErrorDialog = true,
    Function(String? message)? onError,
  }) async {
    // try {
    Query _query = _firestore.collection(collection);

    if (ownerUID != null) {
      _query = _query.where("ownerInfo.uid", isEqualTo: ownerUID);
    }

    QuerySnapshot _doc;

    _doc = await _query
        .orderBy("createdAt", descending: true)
        .get()
        .catchError((error) async {
      printError(info: error);
      if (isErrorDialog) {
        await GetxFire.openDialog.messageError(error.message.toString(),
            title: error.code.toString());
      } else {
        await GetxFire.hideProgressHud();
      }
      if (onError != null) onError(error);
      // return this;
    });
    return _doc.docs;
    // } catch (e) {
    //   GetxFire.openDialog.messageError(e.toString());
    //   rethrow;
    // }
  }

  Future<List<QueryDocumentSnapshot>> searchData({
    required String collection,
    String? ownerUID,
    required String search,
    bool isErrorDialog = true,
    Function(String? message)? onError,
  }) async {
    // try {
    Query _query = _firestore.collection(collection);

    if (ownerUID != null) {
      _query = _query.where("ownerUID", isEqualTo: ownerUID);
    }

    _query =
        _query.where('searchIndex', arrayContains: search.toLowerCase().trim());

    QuerySnapshot _doc = await _query
        .orderBy("createdAt", descending: true)
        .get()
        .catchError((error) {
      if (isErrorDialog) GetxFire.openDialog.messageError(error.toString());
      if (onError != null) onError(error);
      // return null;
    });
    return _doc.docs;
    // } catch (e) {
    //   GetxFire.openDialog.messageError(e.toString());
    //   rethrow;
    // }
  }

  Future<DocumentSnapshot> getDetail({
    required String collection,
    required String id,
    bool isErrorDialog = true,
    Function(String? message)? onError,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection(collection)
        .doc(id)
        .get()
        .catchError((error) async {
      if (isErrorDialog) {
        GetxFire.openDialog.messageError(error.toString());
      } else {
        await GetxFire.hideProgressHud();
      }
      if (onError != null) onError(error);
    });
    return doc;
  }

  Future<void> deleteData({
    required String collection,
    required String id,
    FileModel? photo,
    bool isErrorDialog = true,
    Function(String? message)? onError,
  }) async {
    // try {
    return await _firestore
        .collection(collection)
        .doc(id)
        .delete()
        .then((_) async {
      if (photo != null) {
        await StorageService().deleteFile(photo.filename!,
            fileType: photo.type!, folder: photo.folder!);
      }
    }).catchError((error) async {
      if (isErrorDialog) {
        GetxFire.openDialog.messageError(error.toString());
      } else {
        await GetxFire.hideProgressHud();
      }
      if (onError != null) onError(error);
      return null;
    });
    // } catch (e) {
    //   GetxFire.openDialog.messageError(e.toString());
    //   rethrow;
    // }
  }

  Stream<QuerySnapshot> streamData({
    required String collection,
    String? collectionChild,
    String? idChild,
    bool isErrorDialog = true,
    Function(String? message)? onError,
  }) {
    if (collectionChild == null && idChild == null) {
      return _firestore
          .collection(collection)
          // .orderBy("dateCreated", descending: true)
          .snapshots();
    } else {
      return _firestore
          .collection(collection)
          .doc(idChild)
          .collection(collectionChild!)
          // .orderBy("dateCreated", descending: true)
          .snapshots();
    }
  }

  Stream<DocumentSnapshot> streamDetail({
    required String collection,
    String? collectionChild,
    required String id,
    String? idChild,
    Map<String, dynamic>? data,
    bool isErrorDialog = true,
    Function(String? message)? onError,
  }) {
    if (collectionChild == null) {
      return _firestore
          // .doc(uid)
          .collection(collection)
          .doc(id)
          // .orderBy("dateCreated", descending: true)
          .snapshots();
    } else {
      return _firestore
          .collection(collection)
          .doc(id)
          .collection(collectionChild)
          .doc(idChild)
          // .orderBy("dateCreated", descending: true)
          .snapshots();
    }
  }
}
