import 'dart:async';

import 'package:flutter/material.dart';

import 'handle_firebase_notification.dart';

class FirebaseNotificationCallbackWidget extends StatefulWidget {
  final Function onDataReceived;
  final Widget child;

  FirebaseNotificationCallbackWidget({
    @required this.onDataReceived,
    @required this.child,
  });

  @override
  _FirebaseNotificationCallbackWidgetState createState() =>
      _FirebaseNotificationCallbackWidgetState();
}

class _FirebaseNotificationCallbackWidgetState extends State<FirebaseNotificationCallbackWidget> {
  StreamSubscription _stream;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    try {
      _stream = HandleFirebaseNotification.notificationCommunicator.listen((data) {
        print(data.toString());
        widget.onDataReceived(data);
      }, onDone: () {
        print('done');
      });
    } catch (error) {
      print("Stream Error: " + error.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stream.cancel();
  }
}
