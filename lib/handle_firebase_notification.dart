import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handle_firebase_notification/notification_open.dart';

import 'firebase_token.dart';

class HandleFirebaseNotification {
  
  final RouteObserver<PageRoute<dynamic>> _routeObserver = RouteObserver<PageRoute<dynamic>>();

  MethodChannel _channel;
  
  EventChannel _notificationEventChannel;
  Stream<Map<dynamic, dynamic>> _notificationDataStream;
  StreamController<Map<dynamic, dynamic>> _notificationDataCommunicator = StreamController();


  EventChannel _tokenEventChannel;
  Stream<String> _tokenStream;
  StreamController<String> _tokenCommunicator = StreamController();
  


  static HandleFirebaseNotification _instance;
  
  static const _IS_INTERACTING_KEY = 'is_interacting';

  static HandleFirebaseNotification get instance {
    return HandleFirebaseNotification();
  }

  static RouteObserver get routeObserver {
    return HandleFirebaseNotification()._routeObserver;
  }

  static Stream<Map<dynamic, dynamic>> get notificationCommunicator {
    return HandleFirebaseNotification()._notificationDataStream;
  }

  static Stream<String> get tokenCommunicator{
    return HandleFirebaseNotification()._tokenStream;
  }


  factory HandleFirebaseNotification() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel('handle_notification_method');
      final EventChannel eventChannel = const EventChannel('handle_notification_event');
      final EventChannel tokenChannel = const EventChannel('handle_firebase_notification_token');

      _instance = HandleFirebaseNotification.private(
        methodChannel,
        eventChannel,
        tokenChannel,
      );
    }
    return _instance;
  }

  @visibleForTesting
  HandleFirebaseNotification.private(
    this._channel,
    this._notificationEventChannel,
    this._tokenEventChannel,
  ) {
  
  
    listenTokenEventData();
    
    listenNotificationEventData();
    
  }
  
  listenTokenEventData(){
    try{
     
      _tokenEventChannel.receiveBroadcastStream().listen((data){
        print('Token Data in handle_firebase_notification' + data.toString());
        _tokenCommunicator.sink.add(data);
      
      },onDone: (){
        _tokenCommunicator.close();
      });
    
    
      _tokenStream = _tokenCommunicator.stream.asBroadcastStream();
    
    }catch(error){
      print("Error Stream :- " + error.toString());
    }
  
  }
  
  listenNotificationEventData(){
    try {
      _notificationEventChannel.receiveBroadcastStream().listen((data) {
        print('Notification data in handle_firebase_notification ${data.toString()}');
      
        _notificationDataCommunicator.sink.add(data);
      }, onDone: () {
        _notificationDataCommunicator.close();
      });
    
      _notificationDataStream = _notificationDataCommunicator.stream.asBroadcastStream();
    }catch(error){
      print("Error Stream :- " + error.toString());
    }
  }

  static handleNotification(Map<dynamic, dynamic> data, NotificationOpen handler) {
    final isInteracting = data.remove(_IS_INTERACTING_KEY) != null;
    handler.onOpenFromNotification(data, isInteracting);
  }
  
  static getFireBaseToken(String data,FireBaseToken handler){
    //final isInteracting = data.remove(_IS_INTERACTING_KEY) != null;
    handler.fireBaseToken(data);
  }

  Future<String> showNotification(String name, String message, String email) async {
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
}
