part of '../getxfire.dart';

class Auth {
  static Future<UserCredential?>? createUserWithEmailAndPassword({
    required String email,
    required String password,
    required bool isSuccessDialog,
    required bool isErrorDialog,
    Map<String, dynamic>? data,
    Map<String, dynamic>? public,
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
      if (isSuccessDialog)
        OpenDialog.messageSuccess("Create User successfully!");
    } on FirebaseAuthException catch (e) {
      if (onError != null) await onError(e.code, e.message ?? e.toString());
      if (isErrorDialog) OpenDialog.messageError(e.message ?? e.toString());
    } catch (e) {
      if (onError != null) await onError("undefined", e.toString());
      if (isErrorDialog) OpenDialog.messageError(e.toString());
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
      if (isSuccessDialog) OpenDialog.messageSuccess("Sign in successfully!");
    } on FirebaseAuthException catch (e) {
      if (onError != null) await onError(e.code, e.message ?? e.toString());
      if (isErrorDialog) OpenDialog.messageError(e.message ?? e.toString());
    } catch (e) {
      if (onError != null) await onError("undefined", e.toString());
      if (isErrorDialog) OpenDialog.messageError(e.toString());
    }
    return userCredential;
  }

  static Future<UserCredential?>? signInWithEmailAndPassword({
    required String email,
    required String password,
    required bool isSuccessDialog,
    required bool isErrorDialog,
    Map<String, dynamic>? data,
    Map<String, dynamic>? public,
    Function(UserCredential? userCredential)? onSuccess,
    Function(String? code, String? message)? onError,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // userPublicData = {};
      // await updateUserData(data);
      // await updateUserPublic(public);
      // await onLogin(userCredential.user);
      if (onSuccess != null) await onSuccess(userCredential);
      if (isSuccessDialog) OpenDialog.messageSuccess("Sign in successfully!");
    } on FirebaseAuthException catch (e) {
      if (onError != null) await onError(e.code, e.message ?? e.toString());
      if (isErrorDialog) OpenDialog.messageError(e.message ?? e.toString());
    } catch (e) {
      if (onError != null) await onError("undefined", e.toString());
      if (isErrorDialog) OpenDialog.messageError(e.toString());
    }
    return userCredential;
  }
}
