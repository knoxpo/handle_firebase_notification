import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:handle_firebase_notification/notification_open.dart';
import 'firebase_token.dart';
import 'handle_firebase_notification.dart';

mixin FirebaseNotificationPageRouteMixin<T extends StatefulWidget> on State<T>
    implements RouteAware, NotificationOpen ,FireBaseToken {
  StreamSubscription _notificationDataStream;
  StreamSubscription _tokenStream;

  void _startListening() {
  
    try {
      _notificationDataStream = HandleFirebaseNotification.notificationCommunicator.listen((data) {
        print(data.toString());
        HandleFirebaseNotification.handleNotification(data, this);
      }, onDone: () {
        print('done');
      });
    } catch (error) {
      print("Stream Error: " + error.toString());
    }
  
    try {
      _tokenStream = HandleFirebaseNotification.tokenCommunicator.listen((data) {
        print('in mixin --------------> ${data}');
        HandleFirebaseNotification.getFireBaseToken(data, this);
      }, onDone: () {
        print('done');
      });
    } catch (error) {
      print("Token Error: " + error.toString());
    }
  
  
  }


  void _stopListening() {
    _notificationDataStream.cancel();
    _tokenStream.cancel();
  
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    HandleFirebaseNotification.routeObserver.subscribe(this, ModalRoute.of(context));
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
