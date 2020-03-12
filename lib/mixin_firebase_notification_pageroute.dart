import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:handle_firebase_notification/notification_open.dart';

import 'handle_firebase_notification.dart';

mixin FirebaseNotificationPageRouteMixin<T extends StatefulWidget> on State<T>
    implements RouteAware, NotificationOpen {
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

  void _stopListening() {
    _stream.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    HandleFirebaseNotification.routeObserver
        .subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    _startListening();
    print('Second did push');
  }

  @override
  void didPop() {
    _stopListening();
    print('Second  didPop');
  }

  @override
  void didPopNext() {
    _startListening();
    print('Second  didPopNext');
  }

  @override
  void didPushNext() {
    _stopListening();
    print('Second  didPushNext');
  }
}
