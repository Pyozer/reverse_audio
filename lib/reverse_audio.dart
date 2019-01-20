import 'dart:async';

import 'package:flutter/services.dart';

class ReverseAudio {
  static const MethodChannel _channel = const MethodChannel('reverse_audio');

  static Future<String> reverseFile(String originPath, String destPath) async {
    return await _channel.invokeMethod('reverseFile', {
      'originPath': originPath,
      'destPath': destPath,
    });
  }
}
