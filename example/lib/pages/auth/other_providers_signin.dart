// // Copyright 2020 The Chromium Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// // @dart=2.9

// part of '../signin_page.dart';

// class OtherProvidersSignInSection extends StatefulWidget {
//   OtherProvidersSignInSection();

//   @override
//   State<StatefulWidget> createState() => OtherProvidersSignInSectionState();
// }

// class OtherProvidersSignInSectionState
//     extends State<OtherProvidersSignInSection> {
//   final TextEditingController _tokenController = TextEditingController();
//   final TextEditingController _tokenSecretController = TextEditingController();

//   int _selection = 0;
//   bool _showAuthSecretTextField = false;
//   bool _showProviderTokenField = true;
//   String _provider = 'GitHub';

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 alignment: Alignment.center,
//                 child: const Text('Social Authentication',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(top: 16),
//                 alignment: Alignment.center,
//                 child: kIsWeb
//                     ? const Text(
//                         'When using Flutter Web, API keys are configured through the Firebase Console. The below providers demonstrate how this works')
//                     : const Text(
//                         'We do not provide an API to obtain the token for below providers apart from Google '
//                         'Please use a third party service to obtain token for other providers.'),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(top: 16),
//                 alignment: Alignment.center,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     ListTile(
//                       title: const Text('GitHub'),
//                       leading: Radio<int>(
//                         value: 0,
//                         groupValue: _selection,
//                         onChanged: _handleRadioButtonSelected,
//                       ),
//                     ),
//                     Visibility(
//                       visible: !kIsWeb,
//                       child: ListTile(
//                         title: const Text('Facebook'),
//                         leading: Radio<int>(
//                           value: 1,
//                           groupValue: _selection,
//                           onChanged: _handleRadioButtonSelected,
//                         ),
//                       ),
//                     ),
//                     ListTile(
//                       title: const Text('Twitter'),
//                       leading: Radio<int>(
//                         value: 2,
//                         groupValue: _selection,
//                         onChanged: _handleRadioButtonSelected,
//                       ),
//                     ),
//                     ListTile(
//                       title: const Text('Google'),
//                       leading: Radio<int>(
//                         value: 3,
//                         groupValue: _selection,
//                         onChanged: _handleRadioButtonSelected,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Visibility(
//                 visible: _showProviderTokenField && !kIsWeb,
//                 child: TextField(
//                   controller: _tokenController,
//                   decoration: const InputDecoration(
//                       labelText: "Enter provider's token"),
//                 ),
//               ),
//               Visibility(
//                 visible: _showAuthSecretTextField && !kIsWeb,
//                 child: TextField(
//                   controller: _tokenSecretController,
//                   decoration: const InputDecoration(
//                       labelText: "Enter provider's authTokenSecret"),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.only(top: 16),
//                 alignment: Alignment.center,
//                 child: SignInButton(
//                   _provider == 'GitHub'
//                       ? Buttons.GitHub
//                       : (_provider == 'Facebook'
//                           ? Buttons.Facebook
//                           : (_provider == 'Twitter'
//                               ? Buttons.Twitter
//                               : Buttons.GoogleDark)),
//                   text: 'Sign In',
//                   onPressed: () async {
//                     _signInWithOtherProvider();
//                   },
//                 ),
//               ),
//             ],
//           )),
//     );
//   }

//   void _handleRadioButtonSelected(int value) {
//     setState(() {
//       _selection = value;

//       switch (_selection) {
//         case 0:
//           {
//             _provider = 'GitHub';
//             _showAuthSecretTextField = false;
//             _showProviderTokenField = true;
//           }
//           break;

//         case 1:
//           {
//             _provider = 'Facebook';
//             _showAuthSecretTextField = false;
//             _showProviderTokenField = true;
//           }
//           break;

//         case 2:
//           {
//             _provider = 'Twitter';
//             _showAuthSecretTextField = true;
//             _showProviderTokenField = true;
//           }
//           break;

//         default:
//           {
//             _provider = 'Google';
//             _showAuthSecretTextField = false;
//             _showProviderTokenField = false;
//           }
//       }
//     });
//   }

//   void _signInWithOtherProvider() {
//     switch (_selection) {
//       case 0:
//         _signInWithGithub();
//         break;
//       case 1:
//         _signInWithFacebook();
//         break;
//       case 2:
//         _signInWithTwitter();
//         break;
//       default:
//         _signInWithGoogle();
//     }
//   }

//   // Example code of how to sign in with Github.
//   Future<void> _signInWithGithub() async {
//     try {
//       UserCredential userCredential;
//       if (kIsWeb) {
//         GithubAuthProvider githubProvider = GithubAuthProvider();
//         userCredential = await _auth.signInWithPopup(githubProvider);
//       } else {
//         final AuthCredential credential = GithubAuthProvider.credential(
//           _tokenController.text,
//         );
//         userCredential = await _auth.signInWithCredential(credential);
//       }

//       final user = userCredential.user;

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Sign In ${user.uid} with GitHub'),
//       ));
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to sign in with GitHub: $e'),
//         ),
//       );
//     }
//   }

//   // Example code of how to sign in with Facebook.
//   Future<void> _signInWithFacebook() async {
//     try {
//       final AuthCredential credential = FacebookAuthProvider.credential(
//         _tokenController.text,
//       );
//       final User user = (await _auth.signInWithCredential(credential)).user;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Sign In ${user.uid} with Facebook'),
//         ),
//       );
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to sign in with Facebook: $e'),
//         ),
//       );
//     }
//   }

//   // Example code of how to sign in with Twitter.
//   Future<void> _signInWithTwitter() async {
//     try {
//       UserCredential userCredential;

//       if (kIsWeb) {
//         TwitterAuthProvider twitterProvider = TwitterAuthProvider();
//         await _auth.signInWithPopup(twitterProvider);
//       } else {
//         final AuthCredential credential = TwitterAuthProvider.credential(
//             accessToken: _tokenController.text,
//             secret: _tokenSecretController.text);
//         userCredential = await _auth.signInWithCredential(credential);
//       }

//       final user = userCredential.user;

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Sign In ${user.uid} with Twitter'),
//       ));
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to sign in with Twitter: $e'),
//         ),
//       );
//     }
//   }

//   //Example code of how to sign in with Google.
//   Future<void> _signInWithGoogle() async {
//     try {
//       UserCredential userCredential;

//       if (kIsWeb) {
//         var googleProvider = GoogleAuthProvider();
//         userCredential = await _auth.signInWithPopup(googleProvider);
//       } else {
//         final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
//         final GoogleSignInAuthentication googleAuth =
//             await googleUser.authentication;
//         final googleAuthCredential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         userCredential = await _auth.signInWithCredential(googleAuthCredential);
//       }

//       final user = userCredential.user;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Sign In ${user.uid} with Google'),
//       ));
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to sign in with Google: $e'),
//         ),
//       );
//     }
//   }
// }
