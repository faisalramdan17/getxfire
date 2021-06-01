// library getxfire;

// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui' as ui;
// import 'dart:async';
// import 'package:crypto/crypto.dart';
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:merge_map/merge_map.dart';
// import 'package:permission_handler/permission_handler.dart' as permissionHander;
// import 'package:rxdart/subjects.dart';
// import 'package:algolia/algolia.dart';

// import 'package:location/location.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';

// import 'src/functions.dart';
// part 'src/basefire.dart';
// part 'src/chats.dart';
// part 'src/definitions.dart';
// part 'src/locations.dart';

// /// GetxFire
// ///
// /// Recommendation: instantiate `GetxFire` class into a global variable
// /// and use it all over the app runtime.
// ///
// /// Warning: instantiate it after `initFirebase`. One of good places is insdie
// /// the first widget loaded by `runApp()` or home screen.
// ///
// class GetxFire extends BaseFire {
//   ///
//   /// [remoteConfigFetchInterval] is the interval that the app will fetch remote config data again.
//   /// the unit of [remoteConfigFetchInterval] is minute. In debug mode, it can be set to 1.
//   /// But in release mode, it must not be less than 15. If it is less than 15,
//   /// then it will be escalated to 15.
//   ///
//   /// if [openProfile] is set, user's displayName and photoURL will be saved in
//   /// user's public folder.
//   ///
//   /// GetxFire listens `/translations` collection and fire
//   /// `translationsChange` event on update. The [translations] will be used
//   /// as the initial translation data set.
//   ///
//   Future<void> init({
//     bool openProfile = false,
//     bool enableNotification = false,
//     String? firebaseServerToken,
//     Map<String, Map<dynamic, dynamic>>? settings,
//     Map<String, Map<String, String>>? translations,
//   }) async {
//     this.openProfile = openProfile;
//     this.enableNotification = enableNotification;
//     this.firebaseServerToken = firebaseServerToken;

//     /// Initialize settings.
//     ///
//     /// Note. it must be called before firebase init.
//     if (settings != null) {
//       _settings = mergeMap([_settings!, settings]);
//       settingsChange.add(_settings);
//     }

//     if (translations != null) {
//       translationsChange
//           .add(translations); // Must be called before firebase init
//     }

//     ///
//     return initFirebase().then((firebaseApp) {
//       usersCol = FirebaseFirestore.instance.collection('users');
//       postsCol = FirebaseFirestore.instance.collection('posts');

//       initUser();
//       // initFirebaseMessaging();
//       listenSettingsChange();
//       listenTranslationsChange(translations);

//       /// Initialize or Re-initialize based on the setting's update.
//       settingsChange.listen((settings) {
//         // print('settingsChange.listen() on GetxFire::init() $settings');

//         // Initalize Algolia
//         String? algoliaAppId = appSetting(ALGOLIA_APP_ID);
//         String? apiKey = appSetting(ALGOLIA_ADMIN_API_KEY);
//         if (algoliaAppId != null && apiKey != null) {
//           algolia = Algolia.init(
//             applicationId: algoliaAppId,
//             apiKey: apiKey,
//           );
//         }
//       });

//       isFirebaseInitialized = true;
//       firebaseInitialized.add(isFirebaseInitialized);
//       return firebaseApp;
//     });
//   }

//   /// Checks if the current logged in user is an admin.
//   bool get isAdmin => this.userData?['isAdmin'] == true;

//   /// Checks if a user is currently logged in.
//   /// @deprecated user `isLoggedIn`
//   @deprecated
//   bool get userIsLoggedIn => user != null;

//   /// Checks if no user is logged in.
//   /// @deprecated Use `notLoggedIn`
//   @deprecated
//   bool get userIsLoggedOut => !userIsLoggedIn;

//   /// Register into Firebase with email/password
//   ///
//   /// `authStateChanges` will fire event with login info immediately after the
//   /// user register but before updating user displayName and photoURL meaning.
//   /// This means, when `authStateChanges` event fired, the user have no
//   /// `displayNamd` and `photoURL` in the User data.
//   ///
//   /// The `user` will have updated `displayName` and `photoURL` after
//   /// registration and updating `displayName` and `photoURL`.
//   ///
//   /// Consideration: It cannot have a fixed data type since developers may want
//   /// to add extra data on registration.
//   ///
//   Future<User?> register(
//     Map<String, dynamic> data, {
//     Map<String, dynamic>? public,
//   }) async {
//     assert(data['photoUrl'] == null, 'photoURL must no empty');

//     if (data['email'] == null) throw 'email_is_empty';
//     if (data['password'] == null) throw 'password_is_empty';

//     // print('req: $data');

//     UserCredential userCredential =
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: data['email'],
//       password: data['password'],
//     );

//     userPublicData = {};

//     // For registraion, it is okay that displayName or photoUrl is empty.
//     await updateUserData(data);

//     // Remove default data.
//     // And if there is no more properties to save into document, then save
//     // empty object.
//     data.remove('email');
//     data.remove('password');
//     data.remove('displayName');
//     data.remove('photoURL');

//     // Login Success

//     // Set user extra information
//     await myDoc.set(data);
//     await onRegister(userCredential.user);

//     /// Default meta
//     ///
//     /// It subscribe for the reactions of the user's posts and comments by
//     /// default
//     Map<String, dynamic> defaultPublicData = {
//       notifyPost: true,
//       notifyComment: true,
//       'createdAt': FieldValue.serverTimestamp(),
//     };

//     /// Merge default with new meta data.
//     if (public == null) {
//       public = defaultPublicData;
//     } else {
//       public = mergeMap([defaultPublicData, public]);
//     }

//     /// Default public data
//     await updateUserPublic(public);

//     await updateUserToken();

//     // await updateUserMeta(defaultMeta);

//     onLogin(user);
//     return user;
//   }

//   /// Logs out from Firebase Auth.
//   Future logout() async {
//     userPublicData = {};
//     await GoogleSignIn().signOut();
//     return await FirebaseAuth.instance.signOut();
//   }

//   /// Logs into Firebase Auth.
//   ///
//   /// It can update user displayName, photoURL or other public data while login.
//   ///
//   /// TODO Leave last login timestamp.
//   /// TODO Increment login count
//   /// TODO Leave last login device & IP address.
//   ///
//   Future<User?> login({
//     required String email,
//     required String password,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? public,
//   }) async {
//     // print('email: $email');
//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     userPublicData = {};
//     await updateUserData(data);
//     await updateUserPublic(public);
//     await onLogin(userCredential.user);
//     return userCredential.user;
//   }

//   /// Update displayName or photoURL
//   ///
//   ///
//   Future<void> updateUserData(Map<String, dynamic>? data) async {
//     if (data == null) return;
//     if (data['displayName'] != null && data['photoURL'] != null) {
//       await user?.updateProfile(
//         displayName: data['displayName'],
//         photoURL: data['photoURL'],
//       );
//     } else if (data['displayName'] != null) {
//       await user?.updateProfile(displayName: data['displayName']);
//     } else if (data['photoURL'] != null) {
//       await user?.updateProfile(photoURL: data['photoURL']);
//     }
//     await user?.reload();
//   }

//   /// logs in or register.
//   ///
//   /// This method is for a test purpose. Do not use this method unless you
//   /// really need it.
//   ///
//   /// The input arguments are the same as `register`
//   ///
//   /// [onLogin] will be called after login
//   /// [onRegister] will be called after registration
//   ///
//   /// ```dart
//   /// dynamic user = await ff.loginOrRegister({
//   ///  'email': 'user-a@gmail.com',
//   ///  'password': '12345a,*',
//   ///  'displayName': 'UserA'
//   /// });
//   /// ```
//   ///
//   /// ```dart
//   /// dynamic user = await ff.loginOrRegister(
//   ///  email: 'user-a@gmail.com',
//   ///  password: '12345a,*',
//   ///  data: {
//   ///    'displayName': 'UserA'
//   ///  },
//   ///  public: { ... }
//   /// );
//   /// ```
//   Future<User?> loginOrRegister({
//     String? email,
//     String? password,
//     Map<String, dynamic>? data,
//     Map<String, dynamic>? public,
//     Function? onRegister,
//     Function? onLogin,
//   }) async {
//     try {
//       if (data == null) data = {};

//       if (email != null) data['email'] = email;
//       if (password != null) data['password'] = password;

//       final user = await login(
//           email: data['email'],
//           password: data['password'],
//           data: data,
//           public: public);
//       if (onLogin != null) onLogin(user);
//       return user;
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         final user = await register(data, public: public);
//         if (onRegister != null) onRegister(user);
//         return user;
//       }
//       rethrow;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   /// Update user's profile photo.
//   ///
//   /// This method updates user profile photo faster than `updateProfile`.
//   Future<void> updatePhoto(String url) async {
//     await updateProfile({'photoURL': url});
//     await user?.reload();
//     await onProfileUpdate();
//   }

//   /// Get more posts from Firestore
//   ///
//   /// Posts will be live updated and `ForumData.render()` will be called once they are fected.
//   ///
//   /// This does not fetch again while it is in progress of fetching.
//   /// Todo bug check: does the last post in the list disappear when a new post added(created)?
//   fetchPosts(ForumData forum) {
//     if (forum.shouldNotFetch) return;
//     // print('category: ${forum.category}');
//     // print('should fetch?: ${forum.shouldFetch}');
//     forum.updateScreen(RenderType.fetching);

//     // Prepare query
//     Query<ForumData> postsQuery =
//         postsCol.where('category', isEqualTo: forum.category);
//     if (forum.uid != null) {
//       postsQuery = postsQuery.where('uid', isEqualTo: forum.uid);
//     }
//     postsQuery = postsQuery.orderBy('createdAt', descending: true);

//     // Set default limit
//     int limit =
//         _settings?['forum']['no-of-posts-per-fetch'] ?? forum.noOfPostsPerFetch;

//     // If it has specific limit on settings set the corresponding settings.
//     if (_settings?[forum.category] != null &&
//         _settings?[forum.category]['no-of-posts-per-fetch'] != null)
//       limit = _settings?[forum.category]['no-of-posts-per-fetch'];
//     postsQuery = postsQuery.limit(limit);

//     // Fetch from the last post that had been fetched.
//     if (forum.posts.isNotEmpty) {
//       postsQuery = postsQuery.startAfter([forum.posts.last['createdAt']]);
//     }

//     // Listen to coming posts.
//     forum.postQuerySubscription =
//         postsQuery.snapshots().listen((QuerySnapshot snapshot) {
//       forum.fetched = true;
//       // If snapshot size is 0, means no documents has been fetched.
//       if (snapshot.size == 0) {
//         if (forum.posts.isEmpty) {
//           forum.status = ForumStatus.noPosts;
//         } else {
//           forum.status = ForumStatus.noMorePosts;
//         }
//       } else if (snapshot.docs.length < limit) {
//         forum.status = ForumStatus.noMorePosts;
//       }

//       forum.updateScreen(RenderType.finishFetching);
//       snapshot.docChanges.forEach((DocumentChange documentChange) {
//         final Map<String, dynamic> post = documentChange.doc.data();
//         post['id'] = documentChange.doc.id;

//         // print('post:');
//         // print(post);

//         if (documentChange.type == DocumentChangeType.added) {
//           // [createdAt] is null on author mobile (since FieldValue.serverTime make the event fire twice).
//           if (post['createdAt'] == null) {
//             forum.posts.insert(0, post);
//           }

//           // [createdAt] is not null on other user's mobile and have the
//           // biggest value among other posts.
//           /// bug - `Unhandled Exception: NoSuchMethodError: The getter 'microsecondsSinceEpoch' was called on null.` appears
//           ///   when some complicated async work happens together quickly like login, registration, creating photosß
//           else if (forum.posts.isNotEmpty &&
//               post['createdAt'].microsecondsSinceEpoch >
//                   forum.posts[0]['createdAt'].microsecondsSinceEpoch) {
//             forum.posts.insert(0, post);
//           }

//           // Or, it is a post that should be added at the bottom for infinite
//           // page scrolling.
//           else {
//             forum.posts.add(post);
//           }

//           if (post['comments'] == null) post['comments'] = [];

//           // Have a placeholder for all the posts' comments change subscription.
//           forum.commentsSubcriptions[post['id']] = FirebaseFirestore.instance
//               .collection('posts/${post['id']}/comments')
//               .orderBy('order', descending: true)
//               .snapshots()
//               .listen((QuerySnapshot snapshot) {
//             snapshot.docChanges.forEach((DocumentChange commentsChange) {
//               final Map<String, dynamic> commentData =
//                   commentsChange.doc.data();
//               commentData['id'] = commentsChange.doc.id;

//               /// comment added
//               if (commentsChange.type == DocumentChangeType.added) {
//                 // TODO For comments loading on post view, it does not need to loop.
//                 // TODO Only for newly created comment needs to have loop and find a position to insert.
//                 int found = (post['comments'] as List).indexWhere(
//                     (c) => c['order'].compareTo(commentData['order']) < 0);
//                 if (found > -1) {
//                   post['comments'].insert(found, commentData);
//                 } else {
//                   post['comments'].add(commentData);
//                 }

//                 forum.updateScreen(RenderType.commentCreate);
//               }

//               // comment modified
//               else if (commentsChange.type == DocumentChangeType.modified) {
//                 final int ci = post['comments']
//                     .indexWhere((c) => c['id'] == commentData['id']);

//                 // print('comment index : $ci');
//                 if (ci > -1) {
//                   post['comments'][ci] = commentData;
//                 }
//                 forum.updateScreen(RenderType.commentUpdate);
//               }

//               // comment deleted
//               else if (commentsChange.type == DocumentChangeType.removed) {
//                 post['comments']
//                     .removeWhere((c) => c['id'] == commentData['id']);
//                 forum.updateScreen(RenderType.commentDelete);
//               }
//             });
//           });
//         }

//         /// post update
//         else if (documentChange.type == DocumentChangeType.modified) {
//           // print('post updated');
//           // print(post.toString());

//           final int i = forum.posts.indexWhere((p) => p['id'] == post['id']);
//           if (i > -1) {
//             // after post is updated, it doesn't have the 'comments' data.
//             // so it needs to be re-inserted.
//             post['comments'] = forum.posts[i]['comments'];
//             forum.posts[i] = post;
//           }
//           forum.updateScreen(RenderType.postUpdate);
//         }

//         /// post delete
//         else if (documentChange.type == DocumentChangeType.removed) {
//           // When post is deleted, also remove comment list subscription to avoid memory leak.
//           forum.commentsSubcriptions[post['id']].cancel();
//           forum.posts.removeWhere((p) => p['id'] == post['id']);
//           forum.updateScreen(RenderType.postDelete);
//         } else {
//           assert(false, 'This is error');
//         }
//       });

//       forum.updateScreen(RenderType.finishFetching);
//     });
//   }

//   /// Edits (create/update) a post document.
//   ///
//   /// [data] is a type of [Map<String, dynamic>] which will be save into firebase as a post document.
//   ///
//   ///
//   /// `data['id']` can either contain a value or null.
//   /// - If it has value, it is considered as update a post document.
//   /// - If it is null, it is considered as creating a post document.
//   ///
//   /// `data['title']` and `data['content']` values are required.
//   /// - Those values are also used when sending a push notification.
//   ///
//   ///
//   /// This method returns document id of the post.
//   ///
//   /// ```dart
//   /// ff.editPost({
//   ///     'id': 1,                    // can be null for creating a post.
//   ///     'title': 'some title',
//   ///     'content': 'some content',
//   ///     // Other information can be added ...
//   /// });
//   /// ```
//   Future<String> editPost(Map<String, dynamic> data) async {
//     // print('data: $data');
//     if (notLoggedIn) throw LOGIN_FIRST;
//     if (data['category'] == null || data['category'] == '') {
//       throw CATEGORY_EMPTY;
//     }

//     /// This code causes one document read and slow down the speed.
//     /// * But write is really rear compaing to read and it would not cause a big performance problem.
//     Map category = (await categoryDoc(data['category']).get()).data();
//     if (category == null) throw CATEGORY_NOT_EXISTS;

//     data['displayName'] = user.displayName;
//     data['photoURL'] = user.photoURL;

//     // Create
//     if (data['id'] == null) {
//       data.remove('id');
//       data['uid'] = user.uid;
//       data['createdAt'] = FieldValue.serverTimestamp();
//       data['updatedAt'] = FieldValue.serverTimestamp();
//       DocumentReference doc = await postsCol.add(data);

//       /// Since push notification takes time, do indexing comes first.

//       final String algoliaAppId = appSetting(ALGOLIA_APP_ID);
//       if (algoliaAppId != null) {
//         await addSearchIndex(
//           path: doc.path,
//           title: data['title'],
//           content: data['content'],
//         );
//       }

//       /// todo do more customization on title or body is empty.
//       if (data['title'] == null || data['title'] == '') {
//         data['title'] = '${user.displayName} has created a post';
//       }
//       if (data['content'] == null || data['content'] == '') {
//         data['content'] = '${user.displayName} has created a post';
//       }
//       sendNotification(
//         data['title'],
//         data['content'],
//         screen: 'postView',
//         id: doc.id,
//         topic: NotificationOptions.post(data['category']),
//       );
//       return doc.id;
//     }

//     // Update
//     else {
//       data['updatedAt'] = FieldValue.serverTimestamp();
//       await postsCol.doc(data['id']).set(
//             data,
//             SetOptions(merge: true),
//           );

//       final String algoliaAppId = appSetting(ALGOLIA_APP_ID);
//       if (algoliaAppId != null) {
//         await addSearchIndex(
//           path: postsCol.doc(data['id']).path,
//           title: data['title'],
//           content: data['content'],
//         );
//       }
//       return data['id'];
//     }
//   }

//   /// Edits (create/update) a comment document.
//   ///
//   /// [data] is the comment to save into comment document.
//   ///
//   /// If `data['id']` has value, then it will update the comment document.
//   ///
//   /// If `data['id']` is null, then it will create a new comment.
//   /// - In this case, [parentIndex] has the index of position in
//   /// [post.comments] array to get `order` of comment position. then, it will
//   /// insert the `order` into the comment. Then, when the comments are listed,
//   /// It will be sorted in proper order.
//   ///
//   ///
//   ///```dart
//   /// ff.editComment(
//   ///     data,
//   ///     postData,
//   ///     parentIndex: 1,
//   /// );
//   ///```
//   Future editComment(
//     Map<String, dynamic> data,
//     Map<String, dynamic> post, {
//     int parentIndex,
//   }) async {
//     final commentsCol = commentsCollection(post['id']);
//     data.remove('postid');

//     // print('ref.path: ' + commentsCol.path.toString());

//     data['displayName'] = user.displayName;
//     data['photoURL'] = user.photoURL;

//     /// Create
//     if (data['id'] == null) {
//       // get order
//       data['order'] = getCommentOrderOf(post, parentIndex);
//       data['uid'] = user.uid;

//       // get depth
//       dynamic parent = getCommentParent(post['comments'], parentIndex);
//       data['depth'] = parent == null ? 0 : parent['depth'] + 1;
//       data['createdAt'] = FieldValue.serverTimestamp();
//       data['updatedAt'] = FieldValue.serverTimestamp();
//       // print('comment create data: $data');
//       final DocumentReference doc = await commentsCol.add(data);
//       addSearchIndex(path: doc.path, title: '', content: data['content']);

//       sendCommentNotification(post, data);
//     }

//     // Update
//     else {
//       data['updatedAt'] = FieldValue.serverTimestamp();
//       await commentsCol.doc(data['id']).set(data, SetOptions(merge: true));
//       addSearchIndex(
//           path: commentsCol.doc(data['id']).path,
//           title: '',
//           content: data['content']);
//     }
//   }

//   /// deletes a post document from posts collection.
//   ///
//   Future<void> deletePost(String postID) {
//     if (postID == null) throw "ERROR_POST_ID_IS_REQUIRED";
//     return postsCol.doc(postID).delete();
//   }

//   /// deletes a comment document from a post's comment collection.
//   ///
//   Future<void> deleteComment(String postID, String commentID) async {
//     if (postID == null) throw "ERROR_POST_ID_IS_REQUIRED";
//     if (commentID == null) throw "ERROR_COMMENT_ID_IS_REQUIRED";
//     await postsCol.doc(postID).collection('comments').doc(commentID).delete();
//   }

//   /// Google sign-in
//   ///
//   ///
//   Future<User> signInWithGoogle() async {
//     // // Trigger the authentication flow
//     // await GoogleSignIn().signOut(); // to ensure you can sign in different user.

//     // final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
//     // if (googleUser == null) throw ERROR_SIGNIN_ABORTED;

//     // // Obtain the auth details from the request
//     // final GoogleSignInAuthentication googleAuth =
//     //     await googleUser.authentication;

//     // // Create a new credential
//     // final GoogleAuthCredential credential = GoogleAuthProvider.credential(
//     //   accessToken: googleAuth.accessToken,
//     //   idToken: googleAuth.idToken,
//     // );

//     // // Once signed in, return the UserCredential
//     // UserCredential userCredential =
//     //     await FirebaseAuth.instance.signInWithCredential(credential);

//     try {
//       UserCredential _authResult;

//       if (kIsWeb) {
//         GoogleAuthProvider googleProvider = GoogleAuthProvider();
//         _authResult =
//             await FirebaseAuth.instance.signInWithPopup(googleProvider);
//       } else {
//         final GoogleSignInAccount googleUserAccount =
//             await GoogleSignIn().signIn();
//         final GoogleSignInAuthentication googleAuth =
//             await googleUserAccount.authentication;
//         final GoogleAuthCredential googleAuthCredential =
//             GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         _authResult = await FirebaseAuth.instance
//             .signInWithCredential(googleAuthCredential);
//       }

//       onSocialLogin(_authResult.user);
//       return _authResult.user;
//     } catch (e) {
//       debugPrint("GOOGLE LOGIN ERROR : $e");
//       return null;
//     }
//   }

//   /// Facebook social login
//   ///
//   ///
//   Future<User> signInWithFacebook() async {
//     // await FacebookAuth.instance
//     //     .logOut(); // Need to logout to avoid 'User logged in as different Facebook user'
//     // final LoginResult result = await FacebookAuth.instance.login();

//     // if (result.status == LoginStatus.success) {
//     //   // you are logged
//     //   final AccessToken accessToken = result.accessToken;

//     //   // Create a credential from the access token
//     //   final FacebookAuthCredential facebookAuthCredential =
//     //       FacebookAuthProvider.credential(accessToken.token);

//     //   // Once signed in, return the UserCredential
//     //   UserCredential userCredential = await FirebaseAuth.instance
//     //       .signInWithCredential(facebookAuthCredential);

//     //   onSocialLogin(userCredential.user);

//     //   return userCredential.user;
//     // } else {
//     //   throw ERROR_SIGNIN_ABORTED;
//     // }
//     return null;
//   }

//   Future<User> signInWithApple() async {
//     final oauthCred = await createAppleOAuthCred();
//     // print(oauthCred);

//     UserCredential userCredential =
//         await FirebaseAuth.instance.signInWithCredential(oauthCred);
//     return userCredential.user;
//   }

//   /// Authenticates a provided phone number by sending a verification code.
//   ///
//   /// [internationalNo] is the number to send the code to.
//   ///
//   /// [resendToken] is optional, and can be used when requesting to resend the verification code.
//   /// - this can be obtained from [onCodeSent]'s return value.
//   ///
//   /// [onCodeSent] will be invoked once the code is generated and sent to the provided number.
//   /// - this will return the [verificationID] and [codeResendToken].
//   /// - [verifcationID] will be used later for verifying the verification code.
//   /// - [codeResendToken] can be used later if the user wants to resend the verification code to the provided number.
//   ///
//   /// [onVerificationCompleted] - This will only be called (on Android) after the automatic code retrieval is performed.
//   /// Some phone may have the automatic code retrieval. Some may not.
//   /// See https://firebase.flutter.dev/docs/auth/phone#verificationcompleted
//   ///
//   /// [onError] will be invoked when an error happen. It contains the error.
//   ///
//   /// ```dart
//   ///  // first time requesting for verification code:
//   ///  f.mobileAuthSendCode(
//   ///     internationalNo,
//   ///     ...
//   ///  );
//   /// ```
//   ///
//   /// ```dart
//   ///  // resending verification code:
//   ///  ff.mobileAuthSendCode(
//   ///     internationalNo,
//   ///     resendToken: codeResendToken,
//   ///     ...
//   ///  );
//   /// ```
//   ///
//   Future<void> mobileAuthSendCode(
//     String internationalNo, {
//     int resendToken,
//     @required onCodeSent(String verificationID, int codeResendToken),
//     @required onError(dynamic error),
//     String linkOrSignIn = linkPhoneAuth,
//     Function onVerificationCompleted,
//   }) {
//     if (internationalNo == null || internationalNo == '') {
//       onError('Input your number');
//     }

//     return FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: internationalNo,

//       // resend token can be null.
//       forceResendingToken: resendToken,

//       // called after the user submitted the phone number.
//       codeSent: (String verID, [int forceResendToken]) async {
//         // print('codeSent!');
//         onCodeSent(verID, forceResendToken);
//       },

//       // called whenever error happens
//       verificationFailed: (FirebaseAuthException e) async {
//         // print('verificationFailed!');
//         onError(e);
//       },

//       // time limit allowed for the automatic code retrieval to operate.
//       timeout: const Duration(seconds: 30),

//       // will invoke after `timeout` duration has passed.
//       codeAutoRetrievalTimeout: (String verID) {},

//       // This will only be called (on Android) after the automatic code retrieval is performed.
//       // Some phone may have the automatic code retrieval. Some may not.
//       // See https://firebase.flutter.dev/docs/auth/phone#verificationcompleted
//       verificationCompleted: (PhoneAuthCredential credential) {
//         if (linkOrSignIn == linkPhoneAuth) {
//           user.linkWithCredential(credential).then((value) {
//             user.reload();
//             onVerificationCompleted(value.user);
//           });
//         } else {
//           FirebaseAuth.instance.signInWithCredential(credential).then((value) {
//             onVerificationCompleted(value.user);
//           });
//         }
//       },
//     );
//   }

//   /// Verify a phone number with the code provided.
//   ///
//   /// [code] is the verification code sent to user's mobile number.
//   ///
//   /// [verificationId] is used to verify the current session, which is associated with the user's mobile number.
//   /// - this can be obtained from the return value of [onCodeSent] after calling the method [mobileAuthSendCode()].
//   ///
//   /// [linkOrSignIn] if is set to `linkPhoneAuth` (which is the default), it will link the Phone Authentication with currently logged account.
//   /// Or if it is set to `signInPhoneAuth`, then it wil signin with the phone number.
//   ///
//   /// After code is verified, this will link/update the current user's phone number.
//   ///
//   /// ```dart
//   /// ff.mobileAuthVerifyCode(
//   ///   code: 999999,                    // verification code
//   ///   verificationId: 'S4mpl3-1D...',  // verification ID
//   /// );
//   /// ```
//   Future mobileAuthVerifyCode({
//     @required String code,
//     @required String verificationId,
//     String linkOrSignIn = linkPhoneAuth,
//   }) async {
//     PhoneAuthCredential creds = PhoneAuthProvider.credential(
//       verificationId: verificationId,
//       smsCode: code,
//     );

//     // This will throw error when
//     //   1: code is incorrect.
//     //   2: the mobile number associated by the verificationId is already in linked with other user.
//     if (linkOrSignIn == linkPhoneAuth) {
//       await user.linkWithCredential(creds);
//       // Inform the app when user phone number has changed
//       await user.reload();
//     } else {
//       await FirebaseAuth.instance.signInWithCredential(creds);
//     }
//   }

//   /// Returns previous choice
//   ///
//   /// If it's first time vote, returns null.
//   /// Or it returns the value of `choice`.
//   // Future<String> _voteChoice(DocumentReference doc) async {
//   //   final snap = await doc.get();
//   //   if (snap.exists) {
//   //     final data = snap.data();
//   //     return data['choice'];
//   //   } else {
//   //     return null;
//   //   }
//   // }

//   /// Returns vote document reference.
//   ///
//   /// [postId] is required
//   ///
//   /// if [commentId] have value, it will return a comment document.
//   // _voteDoc({
//   //   @required String postId,
//   //   String commentId,
//   // }) {
//   //   DocumentReference voteDoc;
//   //   if (commentId == null) {

//   //   }
//   //     voteDoc = postDocument(postId);
//   //   else
//   //     voteDoc = commentDocument(postId, commentId);
//   //   voteDoc = voteDoc.collection('votes').doc(user.uid);
//   //   return voteDoc;
//   // }

//   /// Votes for a post or comment.
//   ///
//   /// [postId] and [choice] are required.
//   ///
//   /// [commentId] is optional.
//   /// - If it is null, this will proceed to vote for a post.
//   /// - If it have a value, this will vote for a comment.
//   ///
//   ///```dart
//   /// ff.vote(
//   ///     postId: 1,
//   ///     commentId: 'can be null if going to vote for post.',
//   ///     choice: VoteChoice.like,
//   /// );
//   ///```
//   Future vote({
//     @required Map<String, dynamic> post,
//     Map<String, dynamic> comment,
//     @required bool choice,
//   }) async {
//     // DocumentReference voteDoc = _voteDoc(postId: postId, commentId: commentId);

//     // final String previousChoice = await _voteChoice(voteDoc);

//     DocumentReference doc;
//     Map<String, dynamic> obj;
//     if (comment == null) {
//       doc = postDocument(post['id']);
//       obj = post;
//     } else {
//       doc = commentDocument(post['id'], comment['id']);
//       obj = comment;
//     }

//     /// If I voted already,
//     if (obj['likes'] != null && obj['likes'][user.uid] != null) {
//       bool previousChoice = obj['likes'][user.uid];
//       if (previousChoice == choice) {
//         await doc.update({'likes.' + user.uid: FieldValue.delete()});
//       } else {
//         await doc.update({'likes.' + user.uid: choice});
//       }
//     } else {
//       await doc.update({'likes.' + user.uid: choice});
//     }

//     // if (previousChoice == null) {
//     //   return voteDoc.set({'choice': choice});
//     // } else if (previousChoice == choice) {
//     //   return voteDoc.set({'choice': ''});
//     // } else {
//     //   return voteDoc.set({'choice': choice});
//     // }
//   }

//   /// Search algolia
//   Future<List<Map<String, dynamic>>> search(String keyword,
//       {int hitsPerPage = 10, int pageNo = 0}) async {
//     String algoliaIndexName = appSetting(ALGOLIA_INDEX_NAME);
//     if (algoliaIndexName == null || algoliaIndexName == "") {
//       throw ALGOLIA_INDEX_NAME_IS_EMPTY;
//     }
//     AlgoliaQuery query = algolia.instance
//         .index(algoliaIndexName)
//         .setPage(pageNo)
//         .setHitsPerPage(hitsPerPage)
//         .query(keyword);
//     AlgoliaQuerySnapshot snap = await query.getObjects();
//     // print('Result count: ${snap.nbHits}'); // no of results
//     List<AlgoliaObjectSnapshot> results = snap.hits; // search result.

//     List<Map<String, dynamic>> searchResults = [];
//     results.forEach((object) {
//       Map<String, dynamic> data = object.data;
//       data['path'] = object.objectID;
//       searchResults.add(data);
//     });
//     return searchResults;
//   }

//   /// Add a data to Algolia search
//   ///
//   /// Data can be a post, a comment, or anything to search.
//   ///
//   /// If there is error it will throw error message.
//   /// If it succeeds, it will return a Map of `{createdAt: 2020-11-20T15:15:21.623Z, objectID: 1316722002}`
//   ///
//   /// TODO add search index update
//   ///
//   /// ```dart
//   /// ff.addSearchIndex(
//   ///   path: 'abc/def', title: 'This is apple', content: 'Oo Oo Apple!'
//   /// )
//   /// .then((value) {
//   ///   print('success: $value');
//   /// }).catchError((e) {
//   ///   print(e);
//   /// });
//   /// ```
//   Future<dynamic> addSearchIndex(
//       {@required String path,
//       @required String title,
//       @required String content}) async {
//     /// If Aloglia settings are not set, then simply return.
//     final String algoliaAppId = appSetting(ALGOLIA_APP_ID);
//     if (algoliaAppId == null) return;

//     String algoliaIndexName = appSetting(ALGOLIA_INDEX_NAME);
//     if (algoliaIndexName == null || algoliaIndexName == "") {
//       throw ALGOLIA_INDEX_NAME_IS_EMPTY;
//     }

//     final added = await algolia.instance.index(algoliaIndexName).addObject({
//       'objectID': path,
//       'title': title,
//       'content': content,
//       'stamp': DateTime.now().millisecondsSinceEpoch,
//     });
//     Map<String, dynamic> data = added.data;
//     print('added data: $data');
//     if (data['createdAt'] != null && data['objectID'] != null) {
//       return data;
//     } else {
//       /// error object: `{message: Method not allowed with this API key, status: 403}`
//       throw data['message'];
//     }
//   }

//   @Deprecated('Use getUserPublicData()')

//   /// Returns user's public document data
//   ///
//   /// If the document does not exist, it returns null.
//   ///
//   /// There is `publicData` map variable which has login user's public document
//   /// data and it's live updated. It is better to use `publicData`, but only if
//   /// you are unsure if `publicData` is available immediately right after login
//   /// or registration, you may use this method.
//   Future<Map<String, dynamic>> getPublicData() async {
//     // if (notLoggedIn) return null;
//     // final snapshot = await publicDoc.get();
//     // if (snapshot.exists) {
//     //   return snapshot.data();
//     // } else {
//     //   return null;
//     // }
//     return getUserPublicData();
//   }

//   /// Get login user's public document as map
//   ///
//   /// Returns empty Map if there is no data or document does not exists.
//   /// `/users/{uid}/meta/public` document would alway exists but just in case
//   /// it does't exist, it return empty Map.
//   Future<Map<String, dynamic>> getUserPublicData() async {
//     final Map<String, dynamic> data = (await publicDoc.get()).data();
//     return data == null ? {} : data;
//   }

//   /// [_usersContainer] to hold other users public document data.
//   ///
//   /// It is a Map container whose key is `uid` and data is the
//   /// `public document` of the user.
//   ///
//   /// Since it is a private member variable, you need to use
//   /// [getOtherUserPublicData] method to access this container.
//   Map<String, Map<String, dynamic>> _usersContainer = {};

//   /// Get other user's public document as map.
//   ///
//   /// Returns `null` if there is no data or document does not exists.
//   /// `/users/{uid}/meta/public` document would alway exists but just in case
//   ///
//   /// It caches in memory. Which means, it will not connect to the database
//   /// again once it retrieved the data.
//   ///
//   /// Use this method when you need to access other user's public data.
//   Future<Map<String, dynamic>> getOtherUserPublicData(String uid) async {
//     if (_usersContainer.containsKey(uid)) return _usersContainer[uid];
//     _usersContainer[uid] = (await publicCol.doc(uid).get()).data();
//     return _usersContainer[uid];
//   }

//   /// Return user language
//   ///
//   /// If the user has set(choose) his language setting, then return it.
//   /// Or if admin set default language, then return it.
//   /// Or if the device has language, then return it.
//   /// Or return 'en' as English.
//   String get userLanguage {
//     if (loggedIn &&
//         userData != null &&
//         userData['language'] != null &&
//         userData['language'] != "") {
//       return userData['language'];
//     } else if (appSetting('default-language') != null) {
//       return appSetting('default-language');
//     } else if (ui.window.locale != null) {
//       return ui.window.locale.languageCode;
//     } else {
//       return 'en';
//     }
//   }

//   @Deprecated('Use ChatRoom class')

//   /// TODO move all the chat relative members to `ChatRoom` or `ChatRoomList`
//   /// Returns the room collection reference
//   ///
//   /// Do not confused with [chatMyRoomListCol] which is user's (indivisual) room
//   /// list while [chatRoomListCol] is the whole chat room container.
//   CollectionReference get chatRoomListCol {
//     return db.collection('chat').doc('info').collection('room-list');
//   }

//   @Deprecated('use ChatRoom')

//   /// Returns `/chat/room/list/{roomId}` document reference
//   ///
//   /// Do not confused with [chatMyRoomInfo] which has the last chat message of
//   /// the chat room of the user's (indivisual) room list, while [chatRoomInfo]
//   /// has the room information which has `moderators`, `users` and all about the
//   /// chat room information.
//   DocumentReference chatRoomInfoDoc(String roomId) {
//     return chatRoomListCol.doc(roomId);
//   }

//   @Deprecated('use ChatBox')

//   /// Returns login user's room list collection `/chat/my-room-list/my-uid` reference.
//   ///
//   ///
//   CollectionReference get chatMyRoomListCol {
//     return chatUserRoomListCol(user.uid);
//   }

//   @Deprecated('use ChatBox')

//   /// Returns document reference of my room (that has last message of the room)
//   ///
//   /// `/chat/my-room-list/my-uid/{roomId}`
//   DocumentReference chatMyRoom(String roomId) {
//     return chatMyRoomListCol.doc(roomId);
//   }

//   @Deprecated('use ChatBox')

//   /// Returns the document data of [roomId] room in my room list.
//   Future<Map<String, dynamic>> chatLastMessage(String roomId) async {
//     return (await chatMyRoom(roomId).get()).data();
//   }

//   @Deprecated('Use ChatRoom')

//   /// Returns my room list collection `/chat/my-room-list/{uid}` reference.
//   ///
//   CollectionReference chatUserRoomListCol(String uid) {
//     return db.collection('chat').doc('my-room-list').collection(uid);
//   }

//   @Deprecated('Use ChatRoom')

//   /// Returns my room (that has last message of the room) document
//   /// reference.
//   DocumentReference chatUserRoomDoc(String uid, String roomId) {
//     return chatUserRoomListCol(uid).doc(roomId);
//   }

//   /// Return the collection of messages of the room id.
//   @Deprecated('Use ChatRoom')
//   CollectionReference chatMessagesCol(String roomId) {
//     return db.collection('chat').doc('messages').collection(roomId);
//   }

//   /// Create a chat room with the [users].
//   ///
//   /// [users] is a list of the UID of users.
//   /// [users] may have [or have not] include the creator's uid.
//   ///
//   /// [title] is the title of the room. If it's empty, then the app should display user names as title.
//   ///
//   ///
//   /// It returns the room information.
//   ///
//   /// Todo move this method to `ChatRoom`
//   @Deprecated('Use ChatRoom() constructor to create a chat room')
//   Future<Map<String, dynamic>> chatCreateRoom({
//     List<String> users,
//     String title,
//   }) async {
//     if (users == null) users = [];
//     users.add(user.uid);
//     users = [
//       ...{...users}
//     ];

//     // String roomId = chatRoomId();
//     // print('roomId: $roomId');

//     Map<String, dynamic> info = {
//       'users': users,
//       'title': title ?? '',
//       'createdAt': FieldValue.serverTimestamp(),
//       'moderators': [user.uid],
//     };

//     DocumentReference roomInfo = await chatRoomListCol.add(info);
//     info['id'] = roomInfo.id;

//     chatSendMessage(info: {
//       'id': info['id'],

//       /// Send message to all users.
//       'users': users
//     }, text: ChatProtocol.roomCreated);
//     return info;
//   }

//   @Deprecated('use ChatBox')

//   /// Update room information
//   ///
//   /// ```dart
//   /// await ff.chatUpdateRoom(info['id'], title: 'new title'); // update title
//   /// ```
//   ///
//   /// Todo move this method to `ChatRoom`
//   Future<void> chatUpdateRoom(String roomId, {String title}) {
//     Map<String, dynamic> data = {};
//     if (title != null) data['title'] = title;
//     return chatRoomInfoDoc(roomId).update(data);
//   }

//   @Deprecated('use ChatRoom')

//   /// Returns the room list info `/chat/room/list/{roomId}` document.
//   ///
//   /// If the room does exists, it returns null.
//   /// The return value has `id` as its room id.
//   ///
//   /// Todo move this method to `ChatRoom`
//   Future<Map<String, dynamic>> chatGetRoomInfo(String roomId) async {
//     DocumentSnapshot snapshot = await chatRoomInfoDoc(roomId).get();
//     if (snapshot.exists == false) return null;
//     Map<String, dynamic> info = snapshot.data();
//     if (info == null) return null;
//     info['id'] = roomId;
//     return info;
//   }

//   @Deprecated('use ChatBox')

//   /// Add a moderator
//   ///
//   /// Only moderator can add a user to moderator.
//   /// The user must be included in `users` array.
//   ///
//   /// Todo move this method to `ChatRoom`
//   Future<void> chatAddModerator(String roomId, String uid) async {
//     Map<String, dynamic> info = await chatGetRoomInfo(roomId);
//     List<String> moderators = [...info['moderators']];
//     moderators.add(uid);
//     await chatRoomInfoDoc(roomId).update({'moderators': moderators});
//   }

//   @Deprecated('use ChatBox')

//   /// Remove a moderator.
//   ///
//   /// Only moderator can remove a moderator.
//   ///
//   /// Todo move this method to `ChatRoom`
//   Future<void> chatRemoveModerator(String roomId, String uid) async {
//     Map<String, dynamic> info = await chatGetRoomInfo(roomId);
//     List<String> moderators = [...info['moderators']];
//     moderators.remove(uid);
//     await chatRoomInfoDoc(roomId).update({'moderators': moderators});
//   }

//   @Deprecated('use ChatBox')

//   /// Add users to chat room
//   ///
//   /// Once a user has entered, `who added who` messages will be updated to all of
//   /// room users.
//   ///
//   /// [users] is a Map of user uid and user name.
//   ///
//   /// See readme
//   ///
//   /// todo before adding user, check if the user is in `blockedUsers` property and if yes, throw a special error code.
//   /// Todo move this method to `ChatRoom`
//   Future<void> chatAddUser(String roomId, Map<String, String> users) async {
//     /// Get new info from server.
//     /// There might be mistake that somehow `info['users']` is not upto date.
//     /// So, it is safe to get room info from server.
//     Map<String, dynamic> info = await chatGetRoomInfo(roomId);

//     List<String> newUsers = [
//       ...List<String>.from(info['users']),
//       ...users.keys.toList()
//     ];
//     newUsers = [
//       ...{...newUsers}
//     ];

//     /// Update users first and then send chat messages to all users.
//     /// In this way, newly entered/added user(s) will have the room in the my-room-list

//     /// Update users array with added user.
//     // print('users:');
//     // print(newUsers);
//     await chatRoomInfoDoc(info['id']).update({'users': newUsers});
//     info['users'] = newUsers;

//     /// Update last message of room users.
//     // print('newUserNames:');
//     // print(users.values.toList());
//     await chatSendMessage(info: info, text: ChatProtocol.enter, extra: {
//       'newUsers': users.values.toList(),
//     });
//   }

//   @Deprecated('use ChatRoom')

//   /// User leaves a room.
//   ///
//   /// Once a user has left, the user will not be able to update last message of
//   /// room users. So, before leave, it should update 'leave' last message of room users.
//   ///
//   /// For moderator to block user, see [chatBlockUser]
//   ///
//   /// [roomId] is the chat room id.
//   /// [uid] is the user to be kicked out by moderator.
//   /// [userName] is the userName to leave or to be kicked out. and it is required.
//   /// [text] is the text to send to all users.
//   ///
//   /// This method throws permission error when a user try to remove another user.
//   /// But admin can remove other users.
//   ///
//   ///
//   /// TODO move this method to `ChatRoom`
//   /// TODO if moderator is leaving, it needs to remove the uid from moderator.
//   /// TODO if the last moderator tries to leave, ask the moderator to add another user to moderator.
//   /// TODO When a user(or a moderator) leaves the room and there is no user left in the room,
//   /// then move the room information from /chat/info/room-list to /chat/info/deleted-room-list.
//   Future<void> chatRoomLeave(String roomId) async {
//     Map<String, dynamic> info = await chatGetRoomInfo(roomId);
//     info['users'].remove(user.uid);

//     /// Update last message of room users that the user is leaving.
//     await chatSendMessage(
//         info: info,
//         text: ChatProtocol.leave,
//         extra: {'userName': user.displayName});

//     /// Update users and blockedUsers first and if there is error return before sending messages to all users.
//     await chatRoomInfoDoc(info['id']).update({'users': info['users']});

//     /// If I am the one who is willingly leave the room, then remove the room in my-room-list.
//     // print(chatMyRoom(roomId).path);
//     await chatMyRoom(roomId).delete();
//   }

//   @Deprecated('use ChatRoom')
//   Future<void> chatKickoutUser(
//       String roomId, String uid, String userName) async {
//     Map<String, dynamic> info = await chatGetRoomInfo(roomId);

//     info['users'].remove(uid);

//     /// Update users to inform all users including kicked-out-user.
//     await chatRoomInfoDoc(info['id']).update({'users': info['users']});

//     await chatSendMessage(
//         info: info, text: ChatProtocol.kickout, extra: {'userName': userName});
//   }

//   @Deprecated('use ChatRoom')

//   /// Moderator removes a user
//   ///
//   /// Todo move this method to `ChatRoom`
//   Future<void> chatBlockUser(String roomId, String uid, String userName) async {
//     Map<String, dynamic> info = await chatGetRoomInfo(roomId);
//     info['users'].remove(uid);

//     List<String> blocked = info['blocked'] ?? [];
//     blocked.add(uid);

//     /// Update users and blockedUsers first to inform by sending a message.
//     await chatRoomInfoDoc(info['id']).update({
//       'users': info['users'],
//       'blockedUsers': blocked,
//     });

//     await chatSendMessage(
//         info: info, text: ChatProtocol.block, extra: {'userName': userName});
//   }

//   /// Send a message to chat room
//   ///
//   /// [info] is the room info that has roomId and users. [info] is required unlike other functions,
//   /// since user may chat often and it will take time to get info from server.
//   /// [info] is a Map containing `id` of the room and `users` of the users who will receive the message.
//   /// `info[usrs]` can be edited to hold only the room creator(moderator) to receive a message that the room has created.
//   /// [extra] will be added to the message
//   ///
//   /// Todo move this method to `ChatRoom`
//   @Deprecated('User ChatRoom')
//   Future<Map<String, dynamic>> chatSendMessage({
//     @required Map<String, dynamic> info,
//     @required String text,
//     Map<String, dynamic> extra,
//   }) async {
//     Map<String, dynamic> message = {
//       'senderUid': user.uid,
//       'senderDisplayName': user.displayName,
//       'senderPhotoURL': user.photoURL,
//       'text': text,

//       /// Time that this message(or last message) was created.
//       'createdAt': FieldValue.serverTimestamp(),

//       /// Make [newUsers] empty string for re-setting previous information.
//       'newUsers': [],

//       if (extra != null) ...extra,
//     };

//     // print('my uid: ${user.uid}');
//     // print('users: ${info['users']}');
//     // print(chatMessagesCol(info['id']).path);
//     await chatMessagesCol(info['id']).add(message);
//     message['newMessages'] =
//         FieldValue.increment(1); // To increase, it must be an udpate.
//     List<Future<void>> messages = [];

//     /// Just incase there are duplicated UIDs.
//     List<String> users = [...info['users'].toSet()];

//     for (String uid in users) {
//       // print(chatUserRoomDoc(uid, info['id']).path);
//       messages.add(chatUserRoomDoc(uid, info['id'])
//           .set(message, SetOptions(merge: true)));
//     }
//     // print('send messages to: ${messages.length}');
//     await Future.wait(messages);
//     return message;
//   }

//   /// open app settings.
//   ///
//   Future<bool> openAppSettings() {
//     return permissionHander.openAppSettings();
//   }

//   Future<Map<String, dynamic>> getUserTokens(String uid) async {
//     if (notLoggedIn) return null;
//     final snapshot = await getUserTokenDoc(uid).get();
//     if (snapshot.exists) {
//       return snapshot.data();
//     } else {
//       return null;
//     }
//   }
// }
