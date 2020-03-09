import 'dart:async';

import 'package:flutter/material.dart';

class DisposeCallbackWidget extends StatefulWidget {
  final Function onDataReceived;

  DisposeCallbackWidget({
    @required Widget child,
    @required this.onDataReceived,
  });

  @override
  _DisposeCallbackWidgetState createState() => _DisposeCallbackWidgetState();
}

class _DisposeCallbackWidgetState extends State<DisposeCallbackWidget> {
  StreamSubscription _stream;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    widget.onDataReceived();
  }
}
