// // Copyright 2020 The Chromium Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// // @dart=2.9

// part of '../signin_page.dart';

// class EmailLinkSignInSection extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => EmailLinkSignInSectionState();
// }

// class EmailLinkSignInSectionState extends State<EmailLinkSignInSection> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();

//   String _userEmail = '';

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//         key: _formKey,
//         child: Card(
//             child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 alignment: Alignment.center,
//                 child: const Text(
//                   'Test sign in with email and link',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (String value) {
//                   if (value.isEmpty) return 'Please enter your email.';
//                   return null;
//                 },
//               ),
//               Container(
//                 padding: const EdgeInsets.only(top: 16),
//                 alignment: Alignment.center,
//                 child: SignInButtonBuilder(
//                   icon: Icons.insert_link,
//                   text: 'Sign In',
//                   backgroundColor: Colors.blueGrey[700],
//                   onPressed: () async {
//                     await _signInWithEmailAndLink();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         )));
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   Future<void> _signInWithEmailAndLink() async {
//     try {
//       _userEmail = _emailController.text;

//       await _auth.sendSignInLinkToEmail(
//           email: _userEmail,
//           actionCodeSettings: ActionCodeSettings(
//               url:
//                   'https://react-native-firebase-testing.firebaseapp.com/emailSignin',
//               handleCodeInApp: true,
//               iOSBundleId: 'io.flutter.plugins.firebaseAuthExample',
//               androidPackageName: 'io.flutter.plugins.firebaseauthexample'));

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('An email has been sent to $_userEmail'),
//         ),
//       );
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Sending email failed'),
//         ),
//       );
//     }
//   }
// }
