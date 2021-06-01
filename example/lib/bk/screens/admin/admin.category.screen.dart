// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:getxfire_example/bk/global_variables.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// enum Mode { create, update, delete }

// class AdminCategoryScreen extends StatefulWidget {
//   @override
//   _AdminCategoryScreenState createState() => _AdminCategoryScreenState();
// }

// class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
//   final idController = TextEditingController();
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();

//   final db = FirebaseFirestore.instance;
//   CollectionReference get categories => db.collection('categories');

//   Mode mode = Mode.create;

//   reset() {
//     setState(() {
//       idController.text = '';
//       mode = Mode.create;
//       titleController.text = '';
//       descriptionController.text = '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Forum Category'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: ff.isAdmin
//             ? Container(
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: idController,
//                       decoration: InputDecoration(labelText: "Category ID"),
//                       enabled: mode == Mode.create,
//                     ),
//                     TextFormField(
//                       controller: titleController,
//                       decoration: InputDecoration(labelText: "Title"),
//                     ),
//                     TextFormField(
//                       controller: descriptionController,
//                       decoration: InputDecoration(labelText: "Description"),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed: reset,
//                           child: Text('Reset'),
//                         ),
//                         ElevatedButton(
//                           onPressed: () async {
//                             String id = idController.text;
//                             String title = titleController.text;
//                             String description = descriptionController.text;
//                             try {
//                               if (mode == Mode.create) {
//                                 DocumentSnapshot doc =
//                                     await categories.doc(id).get();
//                                 if (doc.exists) {
//                                   return Get.snackbar(
//                                       'Error', 'Category exists');
//                                 }
//                               }
//                               await categories.doc(id).set({
//                                 'id': id,
//                                 'title': title,
//                                 'description': description,
//                               }, SetOptions(merge: true));
//                               reset();
//                             } catch (e) {
//                               Get.snackbar('Error', e.toString());
//                             }
//                           },
//                           child: Text('Submit'),
//                         )
//                       ],
//                     ),
//                     StreamBuilder<QuerySnapshot>(
//                       stream: categories.snapshots(),
//                       builder: (c, AsyncSnapshot<QuerySnapshot> snapshot) {
//                         if (snapshot.hasError) {
//                           return Text('Something went wrong');
//                         }

//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return SizedBox.shrink();
//                         }

//                         return ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: snapshot.data.docs.length,
//                           itemBuilder: (cc, i) {
//                             QueryDocumentSnapshot doc =
//                                 snapshot.data.docs.elementAt(i);
//                             final Map<String, dynamic> data = doc.data();

//                             return ListTile(
//                               title: Text(data['id'] + ' : ' + data['title']),
//                               subtitle: Text(data['description']),
//                               trailing: PopupMenuButton<Mode>(
//                                 icon: Icon(Icons.more_vert),
//                                 onSelected: (Mode result) {
//                                   if (result == Mode.update) {
//                                     mode = Mode.update;
//                                     idController.text = data['id'];
//                                     titleController.text = data['title'];
//                                     descriptionController.text =
//                                         data['description'];
//                                   } else if (result == Mode.delete) {
//                                     categories.doc(data['id']).delete();
//                                   }
//                                 },
//                                 itemBuilder: (BuildContext context) =>
//                                     <PopupMenuEntry<Mode>>[
//                                   const PopupMenuItem<Mode>(
//                                     value: Mode.update,
//                                     child: Text('Update'),
//                                   ),
//                                   const PopupMenuItem<Mode>(
//                                     value: Mode.delete,
//                                     child: Text('Delete'),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               )
//             : Text('You are not admin!'),
//       ),
//     );
//   }
// }
