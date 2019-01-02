import 'package:flutter/material.dart';
import 'dart:async';
import 'package:reverse_audio/reverse_audio.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = "UNKNOWN";

  @override
  void initState() {
    super.initState();
    reverseAudioFile();
  }

  Future<void> reverseAudioFile() async {
    //setState(() {
    //  _status = "File is downloading...";
    //});
    // TODO: Download an exemple audio file, save it on device and reverse it
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Status: $_status'),
        ),
      ),
    );
  }
}
