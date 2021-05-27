import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

import 'dart:math';
import 'dart:convert';
import 'package:path/path.dart' as p;

String _createNonce(int length) {
  final random = Random();
  final charCodes = List<int>.generate(length, (_) {
    int codeUnit;

    switch (random.nextInt(3)) {
      case 0:
        codeUnit = random.nextInt(10) + 48;
        break;
      case 1:
        codeUnit = random.nextInt(26) + 65;
        break;
      case 2:
        codeUnit = random.nextInt(26) + 97;
        break;
    }

    return codeUnit;
  });

  return String.fromCharCodes(charCodes);
}

Future<OAuthCredential> createAppleOAuthCred() async {
  final nonce = _createNonce(32);
  print('nonce: $nonce');

  final nativeAppleCred = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    nonce: sha256.convert(utf8.encode(nonce)).toString(),
  );
  return new OAuthCredential(
    providerId: "apple.com", // MUST be "apple.com"
    signInMethod: "oauth", // MUST be "oauth"
    accessToken: nativeAppleCred
        .identityToken, // propagate Apple ID token to BOTH accessToken and idToken parameters
    idToken: nativeAppleCred.identityToken,
    rawNonce: nonce,
  );
}

/// Returns filename with extension.
///
/// @example
///   `/root/users/.../abc.jpg` returns `abc.jpg`
///
String getFilenameFromPath(String path) {
  return path.split('/').last;
}

// /// Returns filename without extension.
// ///
// /// @example
// ///   `/root/users/.../abc.jpg` returns `abc`
// ///
// /// 파일 경로로 부터, 파일 명(확장자 제외)을 리턴한다.
// /// 예) /root/users/.../abc.jpg 로 부터 abc 를 리턴한다.
// String filenameFromPath(String path) {
//   return path.split('/').last.split('.').first;
// }

/// Returns absolute file path from the relative path.
/// [path] must include the file extension.
/// @example
/// ``` dart
/// localFilePath('photo/baby.jpg');
/// ```
Future<String> getAbsoluteTemporaryFilePath(String relativePath) async {
  var directory = await getTemporaryDirectory();
  return p.join(directory.path, relativePath);
}

/// Returns a random string
///
///
String getRandomString({int len = 8, String prefix}) {
  const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
  var t = '';
  for (var i = 0; i < len; i++) {
    t += charset[(Random().nextInt(charset.length))];
  }
  if (prefix != null && prefix.isNotEmpty) t = prefix + t;
  return t;
}
