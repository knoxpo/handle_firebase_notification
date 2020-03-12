import 'package:flutter/material.dart';
import 'package:handle_firebase_notification/handle_firebase_notification.dart';
import 'package:handle_firebase_notification/mixin_firebase_notification_pageroute.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen>
    with FirebaseNotificationPageRouteMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                try {
                  final result = await HandleFirebaseNotification.instance
                      .showNotification(
                    'Pratik',
                    'Hello',
                    'abc@gmail.com',
                  );
                  print(result);
                } catch (error) {
                  print(error.toString());
                }
              },
              child: Text('Press Here'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/second');
              },
              child: Text('Next Screen'),
            )
          ],
        ),
      ),
    );
  }

  void navigate() {
    Navigator.of(context).pushNamed('/second');
  }

  @override
  void onOpenFromNotification(data, bool isInteracting) {
    print(data);
  }
}
