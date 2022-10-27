import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../todos__screen.dart';

class LocalNotifications {
  BuildContext context;
  LocalNotifications(
    this.context,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  // get _onDidReceiveLocalNotification => null;

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: _onDidReceiveLocalNotification);

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _localNotifications.initialize(initializationSettings,
        onDidReceiveNotificationResponse: _onSelectNotification);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("ScheduleNotification001", "Notify Me",
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();
    return const NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  Future<void> showNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime dateTime}) async {
    final details = await _notificationDetails();
    final tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTime, tz.local);
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledAt,
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }

  void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  void _onSelectNotification(NotificationResponse details) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TodosScreen()),
    );
  }
}
