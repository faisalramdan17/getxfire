import 'package:getxfire_example/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PhotoUpload extends StatelessWidget {
  PhotoUpload({@required this.files, @required this.onProgress});
  final List<dynamic> files;
  final Function onProgress;
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.camera_alt),
      onPressed: () async {
        /// Get source of photo
        ImageSource source = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Choose Camera or Gallery'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => Get.back(result: ImageSource.camera),
                  child: Text('Camera'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: ImageSource.gallery),
                  child: Text('Gallery'),
                ),
              ],
            ),
          ),
        );

        if (source == null) return null;

        /// Upload photo
        try {
          final url = await ff.uploadFile(
            folder: 'forum-photos',
            source: source,
            progress: onProgress,
          );

          files.add(url);
          onProgress(0.0);
        } catch (e) {
          Get.snackbar('Error', e.toString());
        }
      },
    );
  }
}
