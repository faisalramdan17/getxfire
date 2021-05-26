
import 'dart:async';

import 'package:flutter/services.dart';

class Getxfire {
  static const MethodChannel _channel =
      const MethodChannel('getxfire');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
