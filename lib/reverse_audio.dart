import 'dart:async';

import 'package:flutter/services.dart';

class ReverseAudio {
  static const MethodChannel _channel =
      const MethodChannel('reverse_audio');

  static Future<String> reverseFile(String originPath, String destPath) async {
    final String result = await _channel.invokeMethod('reverseFile', {
      'originPath': originPath,
      'destPath': destPath,
    });
    return result;
  }
}
