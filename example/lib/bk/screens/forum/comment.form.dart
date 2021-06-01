// import 'package:getxfire_example/bk/global_variables.dart';
// import 'package:getxfire_example/screens/forum/edit_photos.dart';
// import 'package:getxfire_example/screens/forum/photo_upload.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CommentForm extends StatefulWidget {
//   const CommentForm({
//     Key key,
//     @required this.post,
//     this.comment,
//     this.parentIndex,
//     this.onCancel,
//     this.onSuccess,
//   }) : super(key: key);

//   /// the post that this comments belongs to.
//   final Map<String, dynamic> post;

//   /// comment to edit.
//   ///
//   /// If it is not edit, then it must be null.
//   final Map<String, dynamic> comment;

//   /// [parentIndex] is the position of the comment that the new comment is
//   /// going to be attached to in post.comments array
//   ///
//   final int parentIndex;

//   final Function onCancel;
//   final Function onSuccess;

//   @override
//   _CommentFormState createState() => _CommentFormState();
// }

// class _CommentFormState extends State<CommentForm> {
//   final contentController = TextEditingController();

//   List<dynamic> files = [];
//   double uploadProgress = 0;
//   @override
//   initState() {
//     if (widget.comment != null) {
//       files = widget.comment['files'] ?? [];
//       contentController.text = widget.comment['content'];
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             PhotoUpload(
//               files: files,
//               onProgress: (p) => setState(() => uploadProgress = p),
//             ),
//             Expanded(
//               child: TextFormField(controller: contentController),
//             ),
//           ],
//         ),
//         if (uploadProgress > 0)
//           LinearProgressIndicator(
//             value: uploadProgress,
//           ),
//         EditPotos(
//           files: files,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             if (widget.onCancel != null)
//               TextButton(onPressed: widget.onCancel, child: Text('Cancel')),
//             ElevatedButton(
//               onPressed: () async {
//                 if (ff.user.phoneNumber.isBlank &&
//                     ff.appSetting('block-non-verified-users-to-create') ==
//                         true) {
//                   Get.defaultDialog(
//                     middleText: 'Please verify your phone number first!',
//                     textConfirm: 'Ok',
//                     confirmTextColor: Colors.white,
//                     onConfirm: () => Get.back(),
//                   );
//                   return;
//                 }
//                 final data = {
//                   'content': contentController.text,
//                   'files': files
//                 };
//                 if (widget.comment != null) {
//                   data['id'] = widget.comment['id'];
//                 }
//                 try {
//                   await ff.editComment(data, widget.post,
//                       parentIndex: widget.parentIndex);
//                   contentController.text = '';
//                   files = [];
//                   if (widget.onSuccess != null) widget.onSuccess();
//                 } catch (e) {
//                   Get.snackbar('Error', e.toString());
//                 }
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
