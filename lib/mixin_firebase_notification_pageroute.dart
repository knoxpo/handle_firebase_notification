import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'handle_firebase_notification.dart';

mixin FirebaseNotificationPageRouteMixin<T extends StatefulWidget> on State<T>
    implements RouteAware {
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

  void _stopListening() {
    _stream.cancel();
  }

  void onOpenFromNotification(dynamic data);

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
