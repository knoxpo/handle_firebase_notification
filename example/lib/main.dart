import 'dart:async';

import 'package:flutter/material.dart';
import 'package:handle_firebase_notification/handle_firebase_notification.dart';
import 'package:handle_firebase_notification/mixin_firebase_notification_state.dart';
import 'package:handle_firebase_notification_example/second_screen.dart';

import 'first_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with FirebaseNotificationStateMixin {
  Future<void> initialState() async {
    try {
      await HandleFirebaseNotification.instance.setAction('ACTION');
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initialState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [HandleFirebaseNotification.routeObserver],
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        "/": (BuildContext context) => FirstScreen(),
        "/second": (BuildContext context) => SecondScreen()
      },
      //navigatorObservers: [routeObserver],
    );
  }

  @override
  void onOpenFromNotification(data) {
    print('Main Screen ' + data.toString());
  }
}
