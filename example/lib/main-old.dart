import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:getxfire/getxfire.dart';

void main() async {
  /// Make sure you add this line here, so the plugin can access the native side
  WidgetsFlutterBinding.ensureInitialized();

  GetxFire getxFire = GetxFire();
  await getxFire.init(
    settings: {
      'app': {
        'default-language': 'ko',
        'verify-after-register': false,
        'verify-after-login': false,
        'force-verification': false,
        'block-non-verified-users-to-create': false,
        'ALGOLIA_APP_ID': "W42X6RIXO5",
        'ALGOLIA_SEARCH_KEY': "710ce6c481caf890163ba0c24573130f",
        'ALGOLIA_INDEX_NAME': "Dev"
      },
    },
    // translations: translations,
    enableNotification: true,
    firebaseServerToken:
        'AAAAWrjrK94:APA91bGJuMd80xlpz1m8W61PxCS_2Ir_5y4mUcjPMUlNi-wGGaFoXQL9XiUTjBSv8fCSBBWa9-GTsuFNPWfrCF9TFOCmeJgzxtXfuS5EgH1NWEuEmlerbFAz-XIa2DYEpyQWkWwhFQJa',
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {} on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on:'),
        ),
      ),
    );
  }
}
