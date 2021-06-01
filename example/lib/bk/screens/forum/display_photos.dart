// import 'package:flutter/material.dart';

// class DisplayPhotos extends StatelessWidget {
//   DisplayPhotos({
//     Key key,
//     @required this.files,
//   }) : super(key: key);

//   final List<dynamic> files;
//   @override
//   Widget build(BuildContext context) {
//     /// Display uploaded images.
//     if (files == null) {
//       return Container();
//     } else {
//       return Column(
//         children: [
//           for (String url in files) Image.network(url),
//         ],
//       );
//     }
//   }
// }
