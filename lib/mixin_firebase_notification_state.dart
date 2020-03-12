import 'dart:async';

import 'package:flutter/material.dart';
import 'package:handle_firebase_notification/notification_open.dart';

import 'handle_firebase_notification.dart';

mixin FirebaseNotificationStateMixin<T extends StatefulWidget> on State<T>
    implements NotificationOpen {
  StreamSubscription _stream;

  void _startListening() {
    try {
      _stream = HandleFirebaseNotification.communicatorStream.listen((data) {
        print(data.toString());
        HandleFirebaseNotification.handleNotification(data, this);
      }, onDone: () {
        print('done');
      });
    } catch (error) {
      print("Stream Error: " + error.toString());
    }
  }

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
