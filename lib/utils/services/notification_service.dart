import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timebox/constants/cores/notification_constant.dart';
import 'package:universal_html/html.dart' as html;

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();
  static Timer timerNotification = Timer(Duration.zero, () {});

  Future<void> initialize() async {
    tz.initializeTimeZones();

    // init notif channel
    const channel = AndroidNotificationChannel(
      NotificationConstant.notificationId,
      NotificationConstant.notificationChannel,
      description: 'timebox',
      importance: Importance.high,
    );

    // init local notif
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await localNotification.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // create init channel
    await localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // request permission
    await localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  @pragma('vm:entry-point')
  static Future<void> handleNotif({
    required String title,
    required String body,
    required int id,
    required DateTime startTime,
    required DateTime finishTime,
    String? payload,
  }) async {
    const androidNotifDetail = AndroidNotificationDetails(
      NotificationConstant.notificationId,
      NotificationConstant.notificationChannel,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: NotificationConstant.notificationIcon,
      largeIcon: DrawableResourceAndroidBitmap(
        NotificationConstant.notificationIcon,
      ),
      styleInformation: DefaultStyleInformation(true, true),
    );

    var formattedTitle = '<b>$title</b>';
    if (Platform.isIOS) {
      formattedTitle = title;
    }

    const NotificationDetails notifDetail = NotificationDetails(
      android: androidNotifDetail,
    );

    if (startTime.isBefore(finishTime) && startTime.day == finishTime.day) {
      setScheduledNotification(
        id: id,
        title: formattedTitle,
        body: body,
        notificationDetails: notifDetail,
        payload: payload,
        scheduledNotificationDateTime: finishTime,
      );
    }
  }

  void onDidReceiveNotificationResponse(NotificationResponse response) {
    // handle notif payload when user click the notification item
    log("payload ${response.payload}");
  }

  static requestPermissionWeb() async {
    var permission = html.Notification.permission;
    if (permission != 'granted') {
      permission = await html.Notification.requestPermission();
    }
  }

  static handleNotifWeb({
    required String title,
    required String body,
    required DateTime startTime,
    required DateTime finishTime,
  }) async {
    var permission = html.Notification.permission;
    if (permission != 'granted') {
      permission = await html.Notification.requestPermission();
    }

    if (startTime.isBefore(finishTime) && startTime.day == finishTime.day) {
      setTimerNotification(
        Timer(
          Duration(seconds: finishTime.difference(startTime).inSeconds),
          () {
            html.Notification(
              title,
              body: body,
              lang: "id",
              icon: NotificationConstant.notificationIcon,
            );
          },
        ),
      );
    }
  }

  static setTimerNotification(Timer value) {
    timerNotification = value;
  }

  static cancelTimerNotifaction() {
    timerNotification.cancel();
  }

  static setScheduledNotification({
    required int id,
    String? title,
    String? body,
    required NotificationDetails notificationDetails,
    String? payload,
    required DateTime scheduledNotificationDateTime,
  }) async {
    await localNotification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
        tz.local,
      ),
      notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
