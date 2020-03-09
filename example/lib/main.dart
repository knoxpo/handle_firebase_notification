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
    );
  }

  @override
  void onOpenFromNotification(data) {
    print('Main Screen ' + data.toString());
  }
}

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return FirebaseNotificationCallbackWidget(
//      onDataReceived: (data) {
//        print(data);
//      },
//      child: MaterialApp(
//        home: Center(
//          child: Text('Hello World'),
//        ),
//      ),
//    );
//  }
//}
