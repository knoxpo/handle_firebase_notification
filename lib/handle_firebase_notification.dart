import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HandleFirebaseNotification {
  final RouteObserver<PageRoute<dynamic>> _routeObserver =
      RouteObserver<PageRoute<dynamic>>();

  MethodChannel _channel;

  EventChannel _eventChannel;

  StreamController _communicator = StreamController();

  Stream<dynamic> _stream;

  static HandleFirebaseNotification _instance;

  static HandleFirebaseNotification get instance {
    return HandleFirebaseNotification();
  }

  static RouteObserver get routeObserver {
    return HandleFirebaseNotification()._routeObserver;
  }

  static get communicatorStream {
    return HandleFirebaseNotification()._stream;
  }

  factory HandleFirebaseNotification() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('handle_notification_method');
      final EventChannel eventChannel =
          const EventChannel('handle_notification_event');
      _instance =
          HandleFirebaseNotification.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  @visibleForTesting
  HandleFirebaseNotification.private(this._channel, this._eventChannel) {
    _eventChannel.receiveBroadcastStream().listen((data) {
      _communicator.sink.add(data);
    }, onDone: () {
      _communicator.close();
    });
    _stream = _communicator.stream.asBroadcastStream();
  }

  Future<String> showNotification(
      String name, String message, String email) async {
    Map<String, String> details = {
      'name': name,
      'message': message,
      'email': email
    };
    try {
      return await _channel.invokeMethod('notification', details);
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> setAction(String action) async {
    try {
      await _channel.invokeMethod(
        'action',
        {
          'action': action,
        },
      );
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
