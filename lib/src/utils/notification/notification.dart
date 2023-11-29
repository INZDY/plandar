import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:fitgap/src/utils/weather/weather_api_key.dart';
import 'package:fitgap/src/utils/weather/weather_model.dart';
import 'package:fitgap/src/utils/weather/weather_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future initTimeZone() async {
    tz.initializeTimeZones();
  }

  Future<void> initNotifications() async {
    AndroidInitializationSettings initSettingsAndroid =
        const AndroidInitializationSettings('applogo');
    InitializationSettings initSettings =
        InitializationSettings(android: initSettingsAndroid);
    await localNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  //test------------------
  Future showNotification() async {
    return localNotificationsPlugin.show(
        0, 'Test', 'Works!', await notificationDetails());
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max));
  }
  //test-------------------

  Future<void> scheduleNotification() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    Duration offsetTime = DateTime.now().timeZoneOffset;
    print(offsetTime);

    //weather + event setup
    final WeatherService weatherService =
        WeatherService(WeatherAPIKey.weatherAPI);
    String position = await weatherService.getCurrentPosition();

    final List<Map<String, dynamic>> todayEvents =
        await FirestoreService().getEventsInDay(today, tomorrow);

    final List<WeatherForecast> weatherList =
        await weatherService.getWeatherForecast(position, 1);

    for (Map<String, dynamic> event in todayEvents) {
      DateTime eventTime = event['start_date'].toDate();

      for (WeatherForecast weather in weatherList) {
        DateTime weatherTime = DateTime.parse(weather.time);

        if (eventTime.day == weatherTime.day &&
            eventTime.hour == weatherTime.hour) {
          event['weather'] = weather;
        }
      }
    }

    //Notification setup
    const androidChannel = AndroidNotificationDetails(
      'channelId',
      'channelName',
      // channelDescription: 'description',
      importance: Importance.max,
      // priority: Priority.high,
    );

    const platformChannel = NotificationDetails(
      android: androidChannel,
    );

    print(tz.TZDateTime.now(tz.local).add(offsetTime));
    tz.TZDateTime nowTZ = tz.TZDateTime.now(tz.local).add(offsetTime);
    await localNotificationsPlugin.zonedSchedule(
      0,
      'Events Reminder',
      'Event Body',
      nowTZ.add(const Duration(seconds: 5)),
      platformChannel,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
