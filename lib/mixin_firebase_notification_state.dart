import 'dart:async';
import 'package:flutter/material.dart';
import 'package:handle_firebase_notification/notification_open.dart';
import 'firebase_token.dart';
import 'handle_firebase_notification.dart';

mixin FirebaseNotificationStateMixin<T extends StatefulWidget> on State<T>
    implements NotificationOpen, FireBaseToken {
  StreamSubscription _notificationDataStream;
  StreamSubscription _tokenStream;

  void _startListening() {
  
   
      _notificationDataStream = HandleFirebaseNotification.notificationCommunicator.listen((data) {
        print(data.toString());
        HandleFirebaseNotification.handleNotification(data, this);
      }, onDone: () {
        print('done');
      });
  
      _tokenStream = HandleFirebaseNotification.tokenCommunicator.listen((data) {
        print('in mixin --------------> ${data}');
        HandleFirebaseNotification.getFireBaseToken(data, this);
      }, onDone: () {
        print('done');
      });

    
  }

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _notificationDataStream.cancel();
    _tokenStream.cancel();
    super.dispose();
  }
}
