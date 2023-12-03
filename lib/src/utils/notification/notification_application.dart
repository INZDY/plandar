import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:fitgap/src/utils/weather/weather_api_key.dart';
import 'package:fitgap/src/utils/weather/weather_model.dart';
import 'package:fitgap/src/utils/weather/weather_service.dart';
import 'package:intl/intl.dart';

Future<String> dailyReminder(String element) async {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime tomorrow = today.add(const Duration(days: 1));

  //event setup
  final List<Map<String, dynamic>> todayEvents =
      await FirestoreService().getEventsInDay(today, tomorrow);

  String message = '';
  if (element == 'title') {
    message = 'You have ${todayEvents.length} events today';
  } else if (element == 'body') {
    message = todayEvents.isNotEmpty
        ? 'Tap to see events'
        : 'You are free today! Have a nice rest';
  }

  return message;
}

Future<String> showEvent(String element) async {
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

  String message = '';
  Map<String, dynamic> upcomingEvent;
  String startTime, endTime;

  upcomingEvent = todayEvents.firstWhere(
      (event) =>
          event['start_date'].toDate().isAfter(now) ||
          event['start_date'].toDate().isAtSameMomentAs(now),
      orElse: () => {});

  if (element == 'title') {
    message =
        upcomingEvent.isNotEmpty ? upcomingEvent['title'] : 'No upcoming event';
  } else if (element == 'event') {
    if (upcomingEvent.isNotEmpty) {
      startTime =
          DateFormat('HH:mm').format(upcomingEvent['start_date'].toDate());
      endTime = DateFormat('HH:mm').format(upcomingEvent['end_date'].toDate());

      message =
          '${upcomingEvent['allday'] ? 'All Day' : '$startTime - $endTime'}<br>'
          '${upcomingEvent['location'].isNotEmpty ? '${upcomingEvent['location']}<br>' : ''}'
          '${upcomingEvent['weather'].temperature} °C, ${upcomingEvent['weather'].condition}';
    } else {
      message = '$message\nNo more events today! Have a nice rest.';
    }
  } else if (element == 'weather') {
    message = upcomingEvent.isNotEmpty
        ? 'https:${upcomingEvent['weather'].icon}'
        : 'asset://assets/icons/applogo.png';
  }
  return message;
}
