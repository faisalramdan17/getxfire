// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

// ignore_for_file: deprecated_member_use

import 'package:getxfire/getxfire.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'auth/update_user.dart';
part 'auth/user_infocard.dart';
part 'auth/email_password_form.dart';
part 'auth/anonymously.dart';
part 'auth/other_providers_signin.dart';

/// Entrypoint example for various sign-in flows with Firebase.
class SignInPage extends StatefulWidget {
  /// The page title.
  final String title = 'Sign In & Out';

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  void initState() {
    // GetxFire.userChanges().listen((event) => setState(() {}));
    GetxFire.userStateChanges(setState);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FlatButton(
                textColor: Theme.of(context).buttonColor,
                onPressed: () async {
                  GetxFire.openDialog.confirm(
                    content: "Are you sure to sign out?",
                    // lottiePath: "assets/lottie/coffee-favorite.json",
                    lottiePath: GetxFire.lottiePath.THINKING,
                    onYesClicked: () async {
                      final User user = GetxFire.currentUser;
                      if (user == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('No one has signed in.'),
                        ));
                        return;
                      }
                      await GetxFire.signOut();

                      final String uid = user.uid;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('$uid has successfully signed out.'),
                      ));
                    },
                  );
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.red[400],
                  ),
                ),
              ),
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            UserInfoCard(GetxFire.currentUser),
            EmailPasswordForm(),
            // EmailLinkSignInSection(),
            AnonymouslySignInSection(),
            // PhoneSignInSection(Scaffold.of(context)),
            OtherProvidersSignInSection(),
          ],
        );
      }),
    );
  }
}
