part of '../getxfire.dart';

class Auth {
  static Future<UserCredential?>? createUserWithEmailAndPassword({
    required String email,
    required String password,
    required bool isSuccessDialog,
    required bool isErrorDialog,
    // Map<String, dynamic>? data,
    // Map<String, dynamic>? public,
    Function(UserCredential? userCredential)? onSuccess,
    Function(String? code, String? message)? onError,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // userPublicData = {};
      // await updateUserData(data);
      // await updateUserPublic(public);
      // await onLogin(userCredential.user);
      if (onSuccess != null) await onSuccess(userCredential);
      if (isSuccessDialog) {
        GetxFire.openDialog.messageSuccess("Create User successfully!");
      }
    } on FirebaseAuthException catch (e) {
      if (onError != null) await onError(e.code, e.message ?? e.toString());
      if (isErrorDialog) {
        GetxFire.openDialog.messageError(e.message ?? e.toString());
      }
    } catch (e) {
      if (onError != null) await onError("undefined", e.toString());
      if (isErrorDialog) GetxFire.openDialog.messageError(e.toString());
    }
    return userCredential;
  }

  static Future<UserCredential?>? signInAnonymously({
    required bool isSuccessDialog,
    required bool isErrorDialog,
    Function(UserCredential? userCredential)? onSuccess,
    Function(String? code, String? message)? onError,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.signInAnonymously();
      if (onSuccess != null) await onSuccess(userCredential);
      if (isSuccessDialog) {
        GetxFire.openDialog.messageSuccess("Sign in successfully!");
      }
    } on FirebaseAuthException catch (e) {
      if (onError != null) await onError(e.code, e.message ?? e.toString());
      if (isErrorDialog) {
        GetxFire.openDialog.messageError(e.message ?? e.toString());
      }
    } catch (e) {
      if (onError != null) await onError("undefined", e.toString());
      if (isErrorDialog) GetxFire.openDialog.messageError(e.toString());
    }
    return userCredential;
  }

  static Future<UserCredential?>? signInWithEmailAndPassword({
    required String email,
    required String password,
    required bool isSuccessDialog,
    required bool isErrorDialog,
    // Map<String, dynamic>? data,
    // Map<String, dynamic>? public,
    Function(UserCredential? userCredential)? onSuccess,
    Function(String? code, String? message)? onError,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // userCredential.user.getIdTokenResult()
      // userPublicData = {};
      // await updateUserData(data);
      // await updateUserPublic(public);
      // await onLogin(userCredential.user);
      if (onSuccess != null) await onSuccess(userCredential);
      if (isSuccessDialog) {
        GetxFire.openDialog.messageSuccess("Sign in successfully!");
      }
    } on FirebaseAuthException catch (e) {
      if (onError != null) await onError(e.code, e.message ?? e.toString());
      if (isErrorDialog) {
        GetxFire.openDialog.messageError(e.message ?? e.toString());
      }
    } catch (e) {
      if (onError != null) await onError("undefined", e.toString());
      if (isErrorDialog) GetxFire.openDialog.messageError(e.toString());
    }
    return userCredential;
  }

  static Future<UserCredential?>? signInWithGoogle({
    required bool isSuccessDialog,
    required bool isErrorDialog,
    // Map<String, dynamic>? data,
    // Map<String, dynamic>? public,
    Function(UserCredential? userCredential)? onSuccess,
    Function(String? code, String? message)? onError,
  }) async {
    UserCredential? userCredential;
    try {
      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        // Return null to prevent further exceptions if googleSignInAccount is null
        if (googleUser == null) return null;

        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;

        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      // userPublicData = {};
      // await updateUserData(data);
      // await updateUserPublic(public);
      // await onLogin(userCredential.user);
      if (onSuccess != null) await onSuccess(userCredential);
      if (isSuccessDialog) {
        GetxFire.openDialog.messageSuccess("Sign in successfully!");
      }
    } on PlatformException catch (e) {
      debugPrint("[PlatformException] : ${e.code}");
      if (onError != null) await onError(e.code, e.message ?? e.toString());
      if (isErrorDialog) {
        GetxFire.openDialog.messageError(e.message ?? e.toString());
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("[FirebaseAuthException] : ${e.code}");
      if (onError != null) await onError(e.code, e.message ?? e.toString());
      if (isErrorDialog) {
        GetxFire.openDialog.messageError(e.message ?? e.toString());
      }
    } catch (e) {
      debugPrint("[Exception] : ${e.toString()}");
      if (onError != null) await onError("undefined", e.toString());
      if (isErrorDialog) GetxFire.openDialog.messageError(e.toString());
    }
    return userCredential;
  }
}
