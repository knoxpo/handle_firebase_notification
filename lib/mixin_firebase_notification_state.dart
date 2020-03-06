import 'dart:async';

import 'package:flutter/material.dart';

import 'handle_firebase_notification.dart';

mixin FirebaseNotificationStateMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription _stream;

  void _startListening() {
    try {
      _stream = HandleFirebaseNotification.communicatorStream.listen((data) {
        print(data.toString());
        onOpenFromNotification(data);
      }, onDone: () {
        print('done');
      });
    } catch (error) {
      print("Stream Error: " + error.toString());
    }
  }

  void onOpenFromNotification(dynamic data);

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _stream.cancel();
    super.dispose();
  }
}
