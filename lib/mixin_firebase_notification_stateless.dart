import 'dart:async';

import 'package:flutter/material.dart';

import 'handle_firebase_notification.dart';

class StatelessCallbackWidget extends StatefulWidget {
  final Function onDataReceived;
  final Widget child;

  StatelessCallbackWidget({
    @required this.onDataReceived,
    @required this.child,
  });

  @override
  _StatelessCallbackWidgetState createState() =>
      _StatelessCallbackWidgetState();
}

class _StatelessCallbackWidgetState extends State<StatelessCallbackWidget> {
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
      _stream = HandleFirebaseNotification.communicatorStream.listen((data) {
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
