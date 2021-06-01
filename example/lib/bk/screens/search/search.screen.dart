// import 'package:getxfire_example/bk/global_variables.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController searchController = TextEditingController();
//   List<Map<String, dynamic>> results = [];

//   ScrollController scrollController =
//       ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);

//   /// TODO make it as settings
//   int hitsPerPage = 15;

//   int pageNo = 0;

//   bool loading = false;
//   bool noMorePosts = false;
//   @override
//   void initState() {
//     super.initState();

//     scrollController.addListener(() {
//       var isEnd = scrollController.offset >
//           (scrollController.position.maxScrollExtent - 200);
//       if (isEnd) {
//         search();
//       }
//     });
//   }

//   search() async {
//     if (loading || noMorePosts) return;
//     loading = true;

//     List hits;
//     try {
//       hits = await ff.search(searchController.text,
//           hitsPerPage: hitsPerPage, pageNo: pageNo);
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//       return;
//     }
//     if (hits == null || hits.length < hitsPerPage) {
//       noMorePosts = true;
//     }
//     results = [...results, ...hits];
//     loading = false;
//     pageNo++;
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search'),
//       ),
//       body: SingleChildScrollView(
//         controller: scrollController,
//         child: Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: searchController,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   pageNo = 0;
//                   results = [];
//                   noMorePosts = false;
//                   loading = false;
//                   search();
//                 },
//                 child: Text('Search'),
//               ),
//               ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: results.length,
//                 itemBuilder: (context, i) {
//                   return Column(
//                     children: [
//                       ListTile(
//                         title: Text(results[i]['title'] ?? ''),
//                         subtitle: Text(results[i]['content'] ?? ''),
//                         onTap: () {
//                           String path = results[i]['path'];
//                           if (path == null) {
//                             Get.snackbar('Error', 'path does not exists'.tr);
//                           }

//                           String postId = path.split('/')[1];

//                           print('postid: $postId from $path');

//                           Get.snackbar('Post view page', postId);
//                         },
//                       ),
//                       Divider(),
//                     ],
//                   );
//                 },
//               ),
//               if (loading) CircularProgressIndicator(),
//               if (noMorePosts)
//                 Padding(
//                   padding: EdgeInsets.all(32),
//                   child: Text('No more posts'.tr),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
