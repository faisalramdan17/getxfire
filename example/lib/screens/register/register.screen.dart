import 'package:getxfire/getxfire.dart';
import 'package:getxfire_example/global_variables.dart';
import 'package:getxfire_example/keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController favoriteColorController = TextEditingController();

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey('registerScreen'),
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Column(
        children: [
          TextFormField(
            key: ValueKey(Keys.riEmail),
            controller: emailController,
            decoration: InputDecoration(hintText: 'Email Address'),
          ),
          TextFormField(
            key: ValueKey(Keys.riPassword),
            controller: passwordController,
            decoration: InputDecoration(hintText: 'Password'),
          ),
          TextFormField(
            key: ValueKey(Keys.riDisplayName),
            controller: displayNameController,
            decoration: InputDecoration(hintText: 'displayName'),
          ),
          TextFormField(
            key: ValueKey(Keys.riColor),
            controller: favoriteColorController,
            decoration:
                InputDecoration(hintText: 'What is your favorite color?'),
          ),
          ElevatedButton(
            key: ValueKey(Keys.rsButton),
            onPressed: () async {
              setState(() => loading = true);
              try {
                await ff.register({
                  'email': emailController.text,
                  'password': passwordController.text,
                  'displayName': displayNameController.text,
                  'favoriteColor': favoriteColorController.text
                }, public: {
                  notifyPost: true,
                  notifyComment: true,
                });

                setState(() => loading = false);
                if (ff.appSetting('verify-after-register') == true) {
                  Get.toNamed('phone-auth');
                } else {
                  Get.toNamed('home');
                }
              } catch (e) {
                setState(() => loading = false);
                Get.snackbar('Error', e.toString());
              }
            },
            child: loading ? CircularProgressIndicator() : Text('Register'),
          ),
        ],
      ),
    );
  }
}
