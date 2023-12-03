import 'package:fitgap/src/utils/firestore/firestore.dart';
import 'package:fitgap/src/utils/weather/weather_api_key.dart';
import 'package:fitgap/src/utils/weather/weather_model.dart';
import 'package:fitgap/src/utils/weather/weather_service.dart';
import 'package:flutter/material.dart';

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
  Map<String, dynamic> event;
  TimeOfDay startTime, endTime;

  if (element == 'event') {
    if (todayEvents.isNotEmpty) {
      event = todayEvents[0];
      startTime = TimeOfDay.fromDateTime(event['start_date'].toDate());
      endTime = TimeOfDay.fromDateTime(event['end_date'].toDate());

      message = 'You have ${todayEvents.length} events today'
          '<br>First event today:'
          '<br>${event['title']}'
          '<br>${event['allday'] ? 'All Day' : '$startTime : $endTime'}'
          '<br>${event['location'].isNotEmpty ? event['location'] : null}'
          '<br>${event['weather'].temperature} °C, ${event['weather'].condition}';
    } else {
      message = '$message\nYou are free today! Have a nice rest.';
    }
  } else if (element == 'weather') {
    message = todayEvents.isNotEmpty
        ? 'https:${todayEvents[0]['weather'].icon}'
        : 'asset://assets/icons/applogo.png';
  }
  return message;
}
