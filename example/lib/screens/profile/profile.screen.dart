import 'package:getxfire/getxfire.dart';
import 'package:getxfire_example/global_variables.dart';
import 'package:getxfire_example/keys.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<ProfileScreen> {
  TextEditingController displayNameController =
      TextEditingController(text: ff.user?.displayName ?? '');
  TextEditingController favoriteColorController =
      TextEditingController(text: ff.userData['favoriteColor']);

  bool loading = false;
  double uploadProgress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProfileScreen'),
      ),
      body: ff.notLoggedIn
          ? Text('Please login')
          : Column(
              children: [
                StreamBuilder(
                    stream: ff.userChanges,
                    builder: (context, snapshot) {
                      if (ff.notLoggedIn || ff.user.photoURL == null)
                        return Container();
                      return SizedBox(
                          width: 120,
                          height: 120,
                          child: Image.network(ff.user.photoURL));
                    }),
                ElevatedButton(
                  onPressed: () async {
                    ImageSource source = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Choose Camera or Gallery'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  Get.back(result: ImageSource.camera),
                              child: Text('Camera'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Get.back(result: ImageSource.gallery),
                              child: Text('Gallery'),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (source == null) return null;

                    try {
                      if (!ff.user.photoURL.isBlank) {
                        await ff.deleteFile(ff.user.photoURL);
                      }
                      final url = await ff.uploadFile(
                        folder: 'user-profile-photos',
                        source: source,
                        progress: (p) =>
                            setState(() => this.uploadProgress = p),
                      );
                      await ff.updatePhoto(url);
                      setState(() => uploadProgress = 0);
                    } catch (e) {
                      Get.snackbar('Error', e.toString());
                    }
                  },
                  child: Text('Upload Profile Photo'),
                ),
                if (ff.user.photoURL.isBlank)
                  ElevatedButton(
                      onPressed: () async {
                        if (!ff.user.photoURL.isBlank) {
                          await ff.deleteFile(ff.user.photoURL);
                          await ff.updatePhoto('');
                        }
                      },
                      child: Text('Delete Profile Photo')),
                if (uploadProgress != 0) Text('$uploadProgress%'),
                Text('My Email: ${ff.user.email}'),
                TextFormField(
                  key: ValueKey(Keys.pfDisplayName),
                  controller: displayNameController,
                  decoration: InputDecoration(hintText: 'displayName'),
                ),
                TextFormField(
                  key: ValueKey(Keys.pfColor),
                  controller: favoriteColorController,
                  decoration:
                      InputDecoration(hintText: 'What is your favorite color?'),
                ),
                ElevatedButton(
                  key: ValueKey(Keys.pfSubmitButton),
                  onPressed: () async {
                    setState(() => loading = true);
                    try {
                      await ff.updateProfile({
                        'displayName': displayNameController.text,
                        'favoriteColor': favoriteColorController.text
                      }, public: {
                        notifyPost: true,
                        notifyComment: true,
                      });
                      setState(() => loading = false);

                      Get.snackbar('Success', 'Profile has been updated!');
                    } catch (e) {
                      setState(() => loading = false);
                      Get.snackbar('Error', e.toString());
                    }
                  },
                  child: loading ? CircularProgressIndicator() : Text('Update'),
                ),
              ],
            ),
    );
  }
}
