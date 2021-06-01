// import 'package:getxfire_example/bk/global_variables.dart';
// import 'package:getxfire_example/bk/keys.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: ValueKey(Keys.homeScreen),
//       appBar: AppBar(
//         title: Text('app-name'.tr),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'User Information',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: StreamBuilder(
//                 stream: ff.userChanges,
//                 builder: (context, snapshot) {
//                   if (ff.loggedIn) {
//                     return Text(
//                       'UID: ${ff.user.uid}\nEmail: ${ff.user.email}\ndisplayName: ${ff.user.displayName}\nPhone: ${ff.user.phoneNumber}\nColor: ${ff.userData['favoriteColor']}',
//                       key: ValueKey(Keys.hInfo),
//                     );
//                   } else {
//                     return Text(
//                       'Please login',
//                       key: ValueKey(Keys.hPleaseLogin),
//                     );
//                   }
//                 }),
//           ),
//           Divider(),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text('User Buttons'),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   key: ValueKey(Keys.rButton),
//                   onPressed: () => Get.toNamed('register'),
//                   child: Text('Register'),
//                 ),
//                 ElevatedButton(
//                   key: ValueKey(Keys.hLoginButton),
//                   onPressed: () => Get.toNamed('login'),
//                   child: Text('Login'),
//                 ),
//                 ElevatedButton(
//                   key: ValueKey(Keys.hLogoutButton),
//                   onPressed: ff.logout,
//                   child: Text('Logout'),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 ElevatedButton(
//                   key: ValueKey(Keys.hProfileButotn),
//                   onPressed: () => Get.toNamed('profile'),
//                   child: Text('Profile'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Get.toNamed('phone-auth'),
//                   child: Text('Phone Verificatoin'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Get.toNamed('settings'),
//                   child: Text('Settings'),
//                 ),
//               ],
//             ),
//           ),
//           DropdownButton<String>(
//             value: ff.userLanguage,
//             items: [
//               DropdownMenuItem(value: 'id', child: Text('Indonesia')),
//               DropdownMenuItem(value: 'ko', child: Text('Korean')),
//               DropdownMenuItem(value: 'en', child: Text('English')),
//             ],
//             onChanged: (String value) {
//               ff.updateProfile({'language': value});
//             },
//           ),
//           if (ff.isAdmin) ...[
//             Divider(),
//             ElevatedButton(
//               onPressed: () => Get.toNamed('admin'),
//               child: Text('Admin Screen'),
//             ),
//           ],
//           // Divider(),
//           // Wrap(
//           //   children: [
//           //     ElevatedButton(
//           //       onPressed: () =>
//           //           Get.toNamed('forum-edit', arguments: {'category': 'qna'}),
//           //       child: Text('Create a Post'),
//           //     ),
//           //     ElevatedButton(
//           //       onPressed: () =>
//           //           Get.toNamed('forum-list', arguments: {'category': 'qna'}),
//           //       child: Text('QnA Forum'),
//           //     ),
//           //     ElevatedButton(
//           //       onPressed: () => Get.toNamed('forum-list',
//           //           arguments: {'category': 'discussion'}),
//           //       child: Text('Discussion Forum'),
//           //     ),
//           //     ElevatedButton(
//           //       onPressed: () => Get.toNamed('search'),
//           //       child: Text('Search'),
//           //     ),
//           //   ],
//           // ),
//           // Divider(),
//           // ElevatedButton(
//           //   onPressed: () => Get.toNamed('push-notification'),
//           //   child: Text('Push Notification'),
//           // ),
//         ],
//       ),
//     );
//   }
// }
