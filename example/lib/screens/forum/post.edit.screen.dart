import 'package:getxfire_example/global_variables.dart';
import 'package:getxfire_example/screens/forum/edit_photos.dart';
import 'package:getxfire_example/screens/forum/photo_upload.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForumEditScreen extends StatefulWidget {
  @override
  _ForumEditScreenState createState() => _ForumEditScreenState();
}

class _ForumEditScreenState extends State<ForumEditScreen> {
  /// Text box controllers
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  /// Category ID
  String category;

  /// Post to edit
  Map<String, dynamic> post;

  /// Container for uploaded files
  List<dynamic> files = [];

  /// Progress bar percentage
  double uploadProgress = 0;

  @override
  void initState() {
    super.initState();

    /// If `category` is passed, then it is post create.
    if (Get.arguments['category'] != null) {
      category = Get.arguments['category'];
    } else {
      /// Or it's post update.
      post = Get.arguments['post'];
      titleController.text = post['title'];
      contentController.text = post['content'];
      category = post['category'];
      files = post['files'] ?? [];
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  bool get formInvalid => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum Edit'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'title'),
          ),
          TextFormField(
            controller: contentController,
            decoration: InputDecoration(hintText: 'content'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PhotoUpload(
                files: files,
                onProgress: (p) => setState(() => uploadProgress = p),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formInvalid) {
                    return Get.snackbar('title', 'message');
                  }
                  try {
                    await ff.editPost({
                      'id': post == null ? null : post['id'],
                      'category': category,
                      'title': titleController.text,
                      'content': contentController.text,
                      'uid': ff.user.uid,
                      'files': files,
                    });

                    /// Should go back since new post will be updated in real time.
                    Get.back();
                  } catch (e) {
                    Get.snackbar('Error', e.toString());
                  }
                },
                child: Text('submit'.tr),
              ),
            ],
          ),
          if (uploadProgress > 0)
            LinearProgressIndicator(
              value: uploadProgress,
            ),
          EditPotos(
            files: files,
          ),
        ],
      ),
    );
  }
}
