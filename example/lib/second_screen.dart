import 'package:flutter/material.dart';
import 'package:handle_firebase_notification/mixin_firebase_notification_state.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen();

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with FirebaseNotificationStateMixin {
  String _data = 'Second Screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              _data,
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onOpenFromNotification(data, bool isInteracting) {
    print(data);
    setState(() {
      _data = data['name'].toString();
    });
    print('Hello Flutter');
  }
}
