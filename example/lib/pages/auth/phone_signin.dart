// // Copyright 2020 The Chromium Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// // @dart=2.9

// part of '../signin_page.dart';

// class PhoneSignInSection extends StatefulWidget {
//   PhoneSignInSection(this._scaffold);

//   final ScaffoldState _scaffold;

//   @override
//   State<StatefulWidget> createState() => PhoneSignInSectionState();
// }

// class PhoneSignInSectionState extends State<PhoneSignInSection> {
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _smsController = TextEditingController();

//   String _message = '';
//   String _verificationId;

//   @override
//   Widget build(BuildContext context) {
//     if (kIsWeb) {
//       return Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 alignment: Alignment.center,
//                 child: const Text(
//                   'Test sign in with phone number',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const Text(
//                 'Sign In with Phone Number on Web is currently unsupported',
//               )
//             ],
//           ),
//         ),
//       );
//     }

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               alignment: Alignment.center,
//               child: const Text(
//                 'Test sign in with phone number',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             TextFormField(
//               controller: _phoneNumberController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone number (+x xxx-xxx-xxxx)',
//               ),
//               validator: (String value) {
//                 if (value.isEmpty) {
//                   return 'Phone number (+x xxx-xxx-xxxx)';
//                 }
//                 return null;
//               },
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               alignment: Alignment.center,
//               child: SignInButtonBuilder(
//                 icon: Icons.contact_phone,
//                 backgroundColor: Colors.deepOrangeAccent[700],
//                 text: 'Verify Number',
//                 onPressed: _verifyPhoneNumber,
//               ),
//             ),
//             TextField(
//               controller: _smsController,
//               decoration: const InputDecoration(labelText: 'Verification code'),
//             ),
//             Container(
//               padding: const EdgeInsets.only(top: 16),
//               alignment: Alignment.center,
//               child: SignInButtonBuilder(
//                 icon: Icons.phone,
//                 backgroundColor: Colors.deepOrangeAccent[400],
//                 onPressed: _signInWithPhoneNumber,
//                 text: 'Sign In',
//               ),
//             ),
//             Visibility(
//               visible: _message != null,
//               child: Container(
//                 alignment: Alignment.center,
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   _message,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   // Example code of how to verify phone number
//   Future<void> _verifyPhoneNumber() async {
//     setState(() {
//       _message = '';
//     });

//     PhoneVerificationCompleted verificationCompleted =
//         (PhoneAuthCredential phoneAuthCredential) async {
//       await _auth.signInWithCredential(phoneAuthCredential);
//       widget._scaffold.showSnackBar(SnackBar(
//         content: Text(
//             'Phone number automatically verified and user signed in: $phoneAuthCredential'),
//       ));
//     };

//     PhoneVerificationFailed verificationFailed =
//         (FirebaseAuthException authException) {
//       setState(() {
//         _message =
//             'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
//       });
//     };

//     PhoneCodeSent codeSent =
//         (String verificationId, [int forceResendingToken]) async {
//       widget._scaffold.showSnackBar(const SnackBar(
//         content: Text('Please check your phone for the verification code.'),
//       ));
//       _verificationId = verificationId;
//     };

//     PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//         (String verificationId) {
//       _verificationId = verificationId;
//     };

//     try {
//       await _auth.verifyPhoneNumber(
//           phoneNumber: _phoneNumberController.text,
//           timeout: const Duration(seconds: 5),
//           verificationCompleted: verificationCompleted,
//           verificationFailed: verificationFailed,
//           codeSent: codeSent,
//           codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
//     } catch (e) {
//       widget._scaffold.showSnackBar(SnackBar(
//         content: Text('Failed to Verify Phone Number: $e'),
//       ));
//     }
//   }

//   // Example code of how to sign in with phone.
//   Future<void> _signInWithPhoneNumber() async {
//     try {
//       final PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId,
//         smsCode: _smsController.text,
//       );
//       final User user = (await _auth.signInWithCredential(credential)).user;

//       widget._scaffold.showSnackBar(SnackBar(
//         content: Text('Successfully signed in UID: ${user.uid}'),
//       ));
//     } catch (e) {
//       print(e);
//       widget._scaffold.showSnackBar(
//         const SnackBar(
//           content: Text('Failed to sign in'),
//         ),
//       );
//     }
//   }
// }
