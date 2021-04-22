import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:developer';

class Notifications {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  int aYear;
  int aMonth;
  int aDay;
  int aHour;
  int aMin;
  setTime(int year, int month, int day, int hour, int min) {
    aYear = year;
    aMonth = month;
    aDay = day;
    aHour = hour;
    aMin = min;
    var alarmDate = aYear.toString() +
        "," +
        aMonth.toString() +
        "," +
        aDay.toString() +
        "," +
        aHour.toString() +
        ":" +
        aMin.toString();
    log('alarm Date:$alarmDate');
  }

  init() async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("ic_launcher");

    // ignore: todo
    //TODO:iosConfig
    //const IOSInitializationSettings()
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      //IOS
      ////MACOS
    );
    this.flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      "Your channel",
      "channel name",
      "channel description",
      priority: Priority.max,
      importance: Importance.max,
    );
    //Channel IOS
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await this
        .flutterLocalNotificationsPlugin
        .show(0, title, "Notificación inmediata", platformChannelSpecifics
            //Payload es lo que se ejecuta al recibir clickear la notificación
            );
  }

  Future<void> myTimedNotification(int s) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails("id", "name", "description",
          priority: Priority.max, importance: Importance.max),
    );
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = now.add(Duration(seconds: 5));
    await this.flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          "Notificación de tiempo",
          "5 segundos",
          scheduleDate,
          details,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
  }

  Future<void> scheduleweeklyNotification() async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails("id", "name", "description",
          priority: Priority.max, importance: Importance.max),
    );
    await this.flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          "Notificación programada",
          "body",
          _nextinstanceOfDay(),
          details,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
  }

  tz.TZDateTime _nextinstanceOfDay() {
    tz.TZDateTime scheduleDate = _nextInstanceofTime();
    return scheduleDate;
  }

  _nextInstanceofTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, aYear, aMonth, aDay, aHour, aMin);

//SI el día ya pasó
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }
    return scheduleDate;
  }
}
