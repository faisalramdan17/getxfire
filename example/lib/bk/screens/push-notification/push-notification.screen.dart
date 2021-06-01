// import 'package:getxfire_example/bk/global_variables.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PushNotification extends StatefulWidget {
//   @override
//   _PushNotificationState createState() => _PushNotificationState();
// }

// class _PushNotificationState extends State<PushNotification> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Push Notification'.tr),
//       ),
//       body: Column(
//         children: [
//           StreamBuilder(
//               stream: ff.userChanges,
//               builder: (context, snapshot) {
//                 if (ff.userIsLoggedIn) {
//                   return Text(
//                       'Email: ${ff.user.email}, displayName: ${ff.user.displayName}');
//                 } else {
//                   return Text('You are not logged in.');
//                 }
//               }),
//           Divider(),
//           Text('Device Token: '),
//           Text(ff.firebaseMessagingToken),
//           ElevatedButton(
//             onPressed: () async {
//               ff.sendNotification(
//                 'Sample push notification to topic',
//                 'This is the content of push to topic',
//                 screen: 'home',
//                 topic: ff.allTopic,
//                 test: true,
//               );
//             },
//             child: Text('Send notification to all uers(allTopic)'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               ff.sendNotification(
//                 'Sample push notification to me',
//                 'This is the content of push to token',
//                 screen: 'home',
//                 token: ff.firebaseMessagingToken,
//                 test: true,
//               );
//             },
//             child: Text('Send notification to me(my token)'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               ff.sendNotification(
//                 'Sample push notification to my devices',
//                 'This is the content of push to tokens',
//                 screen: 'home',
//                 tokens: [ff.firebaseMessagingToken],
//                 test: true,
//               );
//             },
//             child: Text('Send notification to my devices(multi tokens)'),
//           ),
//         ],
//       ),
//     );
//   }
// }
