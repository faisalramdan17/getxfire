part of '../getxfire.dart';

class StorageService {
  Future<FileModel?> uploadFile({
    required File? imageToUpload,
    required String title,
    required String fileType,
    required String folder,
    String? oldFileName,
  }) async {
    if (imageToUpload == null) return null;

    try {
      var imageFileName = DateTime.now().toString() + " - " + title;

      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(fileType)
          .child(folder)
          .child(imageFileName);

      UploadTask uploadTask;

      final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': imageToUpload.path});

      if (kIsWeb) {
        uploadTask = firebaseStorageRef.putData(
            await imageToUpload.readAsBytes(), metadata);
      } else {
        uploadTask =
            firebaseStorageRef.putFile(File(imageToUpload.path), metadata);
      }

      // uploadTask = firebaseStorageRef.putFile(imageToUpload);

      // TaskSnapshot storageSnapshot = await uploadTask;
      // var downloadUrl = await storageSnapshot.ref.getDownloadURL();

      return await uploadTask.then((res) async {
        // var url = downloadUrl.toString();
        var url = await res.ref.getDownloadURL();

        // debugPrint("===== uploadTask.whenComplete ======");
        // debugPrint("URL = ${url ?? ""}");
        // debugPrint("oldFileName = ${oldFileName ?? ""}");

        if (oldFileName != null) {
          await deleteFile(oldFileName, fileType: fileType, folder: folder);
        }

        return FileModel(
          url: url,
          filename: imageFileName,
          type: fileType,
          folder: folder,
          updatedAt: DateTime.now(),
        );
      });
    } catch (e) {
      GetxFire.openDialog.messageError(e.toString());
      return null;
    }
  }

  Future<bool> deleteFile(
    String? imageFileName, {
    required String fileType,
    required String folder,
  }) async {
    if (imageFileName != null && imageFileName != "") {
      debugPrint("Ref = $fileType/$folder/$imageFileName");
      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child(fileType)
          .child(folder)
          .child(imageFileName);

      try {
        await firebaseStorageRef.delete();
        return true;
      } on FirebaseException catch (e) {
        debugPrint("CODE = ${e.code}");
        if (e.code == 'object-not-found') return true;

        GetxFire.openDialog.messageError(e.toString());
        return false;
      }
    } else {
      return false;
    }
  }
}

// /// Uploads a file to firebase storage and returns the uploaded file's url.
// ///
// /// [folder] is the folder name on Firebase Storage.
// /// [source] is the source of file input. It can be Camera or Gallery.
// /// [maxWidth] is the max width of image to upload.
// /// [quality] is the quality of the jpeg image.
// /// [progress] will return the current percentage of upload task progress.
// ///
// /// `upload-cancelled` error may return when there is no return(no value) from file selection.
// ///
// /// ```dart
// ///
// /// ImageSource source = ... // choose image source
// ///
// /// String url = await ff.uploadFile(
// ///   folder: 'uploads',
// ///   source: source,
// ///   progress: (double p) {
// ///     // do something ..
// ///   },
// /// );
// /// ```
// ///
// Future<String> uploadFile({
//   required String folder,
//   ImageSource source,
//   double maxWidth = 1024,
//   int quality = 90,
//   void progress(double progress),
// }) async {
//   // select file.
//   File file = await pickImage(
//     source: source,
//     maxWidth: maxWidth,
//     quality: quality,
//   );

//   // if no file is selected then do nothing.
//   if (file == null) throw UPLOAD_CANCELLED;
//   // debugPrint('success: file picked: ${file.path}');

//   final ref = FirebaseStorage.instance
//       .ref(folder + '/' + getFilenameFromPath(file.path));

//   UploadTask task = ref.putFile(
//     file,
//     SettableMetadata(customMetadata: {'uid': user.uid}),
//   );
//   task.snapshotEvents.listen((TaskSnapshot snapshot) {
//     double p = (snapshot.bytesTransferred / snapshot.totalBytes);
//     progress(p);
//   });

//   await task;
//   final url = await ref.getDownloadURL();
//   // debugPrint('DOWNLOAD URL : $url');
//   return url;
// }

// /// Deletes a file from firebase storage.
// ///
// /// If the file is not found on the firebase storage, it will ignore the error.
// Future deleteFile(String url) async {
//   Reference ref = FirebaseStorage.instance.refFromURL(url);
//   await ref.delete().catchError((e) {
//     if (!e.toString().contains('object-not-found')) {
//       throw e;
//     }
//   });
// }
