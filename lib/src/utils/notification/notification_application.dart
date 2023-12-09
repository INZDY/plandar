import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:fitgap/src/utils/weather/weather_api_key.dart';
import 'package:fitgap/src/utils/weather/weather_model.dart';
import 'package:fitgap/src/utils/weather/weather_service.dart';
import 'package:intl/intl.dart';

Future<NotificationContent> dailyReminder() async {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime tomorrow = today.add(const Duration(days: 1));

  //event setup
  final List<Map<String, dynamic>> todayEvents =
      await FirestoreService().getEventsInDay(today, tomorrow);

  String title;
  String body;

  title = 'You have ${todayEvents.length} events today';
  body = todayEvents.isNotEmpty
      ? 'Tap to see events'
      : 'You are free today! Have a nice rest';

  return NotificationContent(
    id: 0,
    channelKey: 'scheduled',
    title: title,
    body: body,
    notificationLayout: NotificationLayout.Default,
    largeIcon: 'asset://assets/icons/applogo.png',
    wakeUpScreen: true,
    timeoutAfter: const Duration(hours: 12),
    showWhen: true,
    displayOnForeground: true,
    displayOnBackground: true,
  );
}

Future<NotificationContent> showEvent(int hours) async {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime tomorrow = today.add(const Duration(days: 1));

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
          (event['allday'] ? 12 : eventTime.hour) == weatherTime.hour) {
        event['weather'] = weather;
      }
    }
  }

  Map<String, dynamic> upcomingEvent;
  upcomingEvent = todayEvents.firstWhere(
      (event) =>
          event['start_date']
              .toDate()
              .isAfter(now.add(Duration(hours: hours))) ||
          event['start_date']
              .toDate()
              .isAtSameMomentAs(now.add(Duration(hours: hours))),
      orElse: () => {});

  print(upcomingEvent);

  String title;
  String event;
  String weather;
  String startTime, endTime;

  title =
      upcomingEvent.isNotEmpty ? upcomingEvent['title'] : 'No upcoming event';

  if (upcomingEvent.isNotEmpty) {
    startTime =
        DateFormat('HH:mm').format(upcomingEvent['start_date'].toDate());
    endTime = DateFormat('HH:mm').format(upcomingEvent['end_date'].toDate());

    event =
        '${upcomingEvent['allday'] ? 'All Day' : '$startTime - $endTime'}<br>'
        '${upcomingEvent['location'].isNotEmpty ? '${upcomingEvent['location']}<br>' : ''}'
        '${upcomingEvent['weather'].temperature} °C, ${upcomingEvent['weather'].condition}';
  } else {
    event = 'No more events today! Have a nice rest.';
  }

  weather = upcomingEvent.isNotEmpty
      ? 'https:${upcomingEvent['weather'].icon}'
      : 'asset://assets/icons/applogo.png';

  return NotificationContent(
    id: 1,
    channelKey: 'scheduled',
    title: title,
    body: event,
    notificationLayout: NotificationLayout.BigText,
    largeIcon: weather,
    wakeUpScreen: true,
    timeoutAfter: const Duration(hours: 12),
    showWhen: true,
    displayOnForeground: true,
    displayOnBackground: true,
  );
}
