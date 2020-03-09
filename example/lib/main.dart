import 'package:flutter/material.dart';
import 'package:handle_firebase_notification/mixin_firebase_notification_stateless.dart';

void main() => runApp(MyApp());

//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}

//class _MyAppState extends State<MyApp> with FirebaseNotificationStateMixin {
//  @override
//  @override
//  Widget build(BuildContext context) {
//    return StatelessCallbackWidget(
//      child: MaterialApp(
//        navigatorObservers: [HandleFirebaseNotification.routeObserver],
//        initialRoute: '/',
//        routes: <String, WidgetBuilder>{
//          "/": (BuildContext context) => FirstScreen(),
//          "/second": (BuildContext context) => SecondScreen()
//        },
//        //navigatorObservers: [routeObserver],
//      ),
//      onDataReceived: (data) {
//        print(data);
//      },
//    );
//  }
//
//  @override
//  void onOpenFromNotification(data) {
//    print('Main Screen ' + data.toString());
//  }
//}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatelessCallbackWidget(
      onDataReceived: (data) {
        print(data);
      },
      child: MaterialApp(
        home: Text('Hello World'),
      ),
    );
  }
}
