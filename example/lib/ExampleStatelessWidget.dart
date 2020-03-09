import 'package:flutter/material.dart';
import 'package:handle_firebase_notification_example/DisposeCallbackWidget.dart';

class ExampleStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DisposeCallbackWidget(
      child: Container(),
      onDataReceived: () {},
    );
  }
}
