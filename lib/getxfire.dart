library getxfire;

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

export 'package:image_cropper/image_cropper.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:firebase_storage/firebase_storage.dart';
export 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:image_picker/image_picker.dart';
export 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'dart:convert';
// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:crypto/crypto.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:merge_map/merge_map.dart';
// import 'package:permission_handler/permission_handler.dart' as permissionHander;
// import 'package:rxdart/subjects.dart';
// import 'package:algolia/algolia.dart';

// import 'package:location/location.dart';
// import 'package:geoflutterfire/geoflutterfire.dart';

part 'src/auth.dart';
part 'src/file_model.dart';
part 'src/firestore_service.dart';
part 'src/storage_service.dart';
part 'src/open_dialog.dart';
part 'src/confirm_dialog.dart';
part 'src/info_dialog.dart';
part 'src/progress_hub.dart';
part 'src/ex_button.dart';
part 'src/lottie_path.dart';
part 'src/converter_helper.dart';
part 'src/helper.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

/// GetxFire
///
/// Recommendation: instantiate `GetxFire` class into a global variable
/// and use it all over the app runtime.
///
/// Warning: instantiate it after `initFirebase`. One of good places is insdie
/// the first widget loaded by `runApp()` or home screen.
///
///
class GetxFire {
  ///
  /// Returns an instance using the default [FirebaseApp].
  static FirebaseAuth get auth => _auth;

  ///
  /// Returns an instance using the default [FirestoreService].
  static FirestoreService get firestore => FirestoreService();

  ///
  /// Returns an instance using the default [StorageService].
  static StorageService get storage => StorageService();

  ///
  /// Returns an instance using the default [OpenDialog].
  static OpenDialog get openDialog => OpenDialog();

  ///
  /// Returns an instance using the default [ProgressHud].
  static ProgressHud get progressHud => ProgressHud();

  ///
  /// Returns an instance using the default [LottiePath].
  static LottiePath get lottiePath => LottiePath();

  ///
  /// Returns an instance using the default [ConverterHelper].
  static ConverterHelper get converter => ConverterHelper();

  ///
  /// Returns an instance using the default [Helper].
  static Helper get helper => Helper();

  ///
  /// Returns the current [User] if they are currently signed-in, or `null` if
  /// not.
  ///
  /// You should not use this getter to determine the users current state,
  /// instead use [authStateChanges], [idTokenChanges] or [userChanges] to
  /// subscribe to updates.
  ///
  static User? get currentUser => _auth.currentUser;

  ///
  /// Returns the current [User] Changes if they are currently signed-in, or `null` if
  /// not.
  ///
  /// You should not use this getter to determine the users current state,
  /// instead use [authStateChanges], [idTokenChanges] or [userChanges] to
  /// subscribe to updates.
  ///
  static Stream<User?> userChanges() => _auth.userChanges();

  ///
  /// Returns the current [User] State Changes if they are currently signed-in, or `null` if
  /// not.
  ///
  /// You should not use this getter to determine the users current state,
  /// instead use [authStateChanges], [idTokenChanges] or [userChanges] to
  /// subscribe to updates.
  ///
  static StreamSubscription<User?> userStateChanges(
          void Function(void Function()) setState) =>
      _auth.userChanges().listen((event) => setState(() {}));

  ///
  ///Initializes a new [FirebaseApp] instance by [name] and [options] and returns the created app. This method should be called before any usage of FlutterFire plugins.
  /// The default app instance cannot be initialized here and should be created using the platform Firebase integration.
  ///
  /// [remoteConfigFetchInterval] is the interval that the app will fetch remote config data again.
  /// the unit of [remoteConfigFetchInterval] is minute. In debug mode, it can be set to 1.
  /// But in release mode, it must not be less than 15. If it is less than 15,
  /// then it will be escalated to 15.
  ///
  static Future<FirebaseApp> init({
    String? name,
    FirebaseOptions? options,
    // bool openProfile = false,
    // bool enableNotification = false,
    // String? firebaseServerToken,
    // Map<String, Map<dynamic, dynamic>>? settings,
    // Map<String, Map<String, String>>? translations,
  }) async {
    // this.openProfile = openProfile;
    // this.enableNotification = enableNotification;
    // this.firebaseServerToken = firebaseServerToken;
    /// Initialize settings.
    ///
    /// Note. it must be called before firebase init.
    // if (settings != null) {
    //   _settings = mergeMap([_settings!, settings]);
    //   settingsChange.add(_settings);
    // }

    // if (translations != null) {
    //   translationsChange
    //       .add(translations); // Must be called before firebase init
    // }

    ///
    return Firebase.initializeApp(name: name, options: options)
        .then((firebaseApp) {
      FirebaseFirestore.instance.settings =
          Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

      // usersCol = FirebaseFirestore.instance.collection('users');
      // postsCol = FirebaseFirestore.instance.collection('posts');

      // initUser();
      // // initFirebaseMessaging();
      // listenSettingsChange();
      // listenTranslationsChange(translations);

      // /// Initialize or Re-initialize based on the setting's update.
      // settingsChange.listen((settings) {
      //   // print('settingsChange.listen() on GetxFire::init() $settings');

      //   // Initalize Algolia
      //   String? algoliaAppId = appSetting(ALGOLIA_APP_ID);
      //   String? apiKey = appSetting(ALGOLIA_ADMIN_API_KEY);
      //   if (algoliaAppId != null && apiKey != null) {
      //     algolia = Algolia.init(
      //       applicationId: algoliaAppId,
      //       apiKey: apiKey,
      //     );
      //   }
      // });

      // isFirebaseInitialized = true;
      // firebaseInitialized.add(isFirebaseInitialized);
      return firebaseApp;
    });
  }

  /// Logs in signInAnonymously
  ///
  static Future<UserCredential?> signInAnonymously({
    bool isSuccessDialog = false,
    bool isErrorDialog = true,
    Function(UserCredential? userCredential)? onSuccess,
    Function(String? code, String? message)? onError,
  }) async =>
      Auth.signInAnonymously(
        isSuccessDialog: isSuccessDialog,
        isErrorDialog: isErrorDialog,
        onSuccess: onSuccess,
        onError: onError,
      );

  /// Logs into Firebase Auth by Google Signin.
  ///
  /// It can update user displayName, photoURL or other public data while login.
  ///
  /// TODO Leave last login timestamp.
  /// TODO Increment login count
  /// TODO Leave last login device & IP address.
  ///
  static Future<UserCredential?> signInWithGoogle({
    bool isSuccessDialog = false,
    bool isErrorDialog = true,
    Map<String, dynamic>? data,
    Map<String, dynamic>? public,
    Function(UserCredential? userCredential)? onSuccess,
    Function(String? code, String? message)? onError,
  }) async =>
      Auth.signInWithGoogle(
        data: data,
        public: public,
        isSuccessDialog: isSuccessDialog,
        isErrorDialog: isErrorDialog,
        onSuccess: onSuccess,
        onError: onError,
      );

  /// Logs into Firebase Auth.
  ///
  /// It can update user displayName, photoURL or other public data while login.
  ///
  /// TODO Leave last login timestamp.
  /// TODO Increment login count
  /// TODO Leave last login device & IP address.
  ///
  static Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
    bool isSuccessDialog = false,
    bool isErrorDialog = true,
    Map<String, dynamic>? data,
    Map<String, dynamic>? public,
    Function(UserCredential? userCredential)? onSuccess,
    Function(String? code, String? message)? onError,
  }) async =>
      Auth.signInWithEmailAndPassword(
        email: email,
        password: password,
        data: data,
        public: public,
        isSuccessDialog: isSuccessDialog,
        isErrorDialog: isErrorDialog,
        onSuccess: onSuccess,
        onError: onError,
      );

  /// create User With Email And Password in Firebase Auth.
  ///
  /// It can update user displayName, photoURL or other public data while register.
  ///
  static Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    bool isSuccessDialog = false,
    bool isErrorDialog = true,
    Map<String, dynamic>? data,
    Map<String, dynamic>? public,
    Function(UserCredential? userCredential)? onSuccess,
    Function(String? code, String? message)? onError,
  }) async =>
      Auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
        data: data,
        public: public,
        isSuccessDialog: isSuccessDialog,
        isErrorDialog: isErrorDialog,
        onSuccess: onSuccess,
        onError: onError,
      );

  /// Logs out from Firebase Auth and All Social Login.
  static Future<void> signOut({bool isSocialLogout = true}) async {
    if (isSocialLogout) {
      if (GoogleSignIn().currentUser != null) await GoogleSignIn().signOut();
    }
    return await FirebaseAuth.instance.signOut();
  }
}
