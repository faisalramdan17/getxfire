// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'package:get/get.dart';
import 'package:getxfire_example/core.dart';
import 'package:getxfire/getxfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'pages/register_page.dart';
import 'pages/signin_page.dart';

// Requires that the Firebase Auth emulator is running locally
// e.g via `melos run firebase:emulator`.
/// See https://firebase.flutter.dev/docs/firestore/usage#emulator-usage

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetxFire.init();
  // await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  // FirebaseFirestore.instance.settings = const Settings(
  //   host: 'localhost:8080',
  //   sslEnabled: false,
  //   persistenceEnabled: false,
  // );

  runApp(AuthExampleApp());
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class AuthExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetxFire Example App',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.dark(),
      home: Scaffold(
        body: AuthTypeSelector(),
      ),
    );
  }
}

/// Provides a UI to select a authentication type page
class AuthTypeSelector extends StatelessWidget {
  // Navigates to a new page
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GetxFire Example App'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                icon: Icons.person_add,
                backgroundColor: Colors.indigo,
                text: 'Registration',
                onPressed: () => _pushPage(context, RegisterPage()),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                icon: Icons.verified_user,
                backgroundColor: Colors.orange,
                text: 'Sign In',
                onPressed: () => _pushPage(context, SignInPage()),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: SignInButtonBuilder(
                icon: Icons.movie,
                backgroundColor: Colors.red,
                text: 'Movies List',
                onPressed: () => _pushPage(context, MoviePage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
