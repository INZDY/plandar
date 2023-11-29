import 'dart:convert';
import 'package:fitgap/src/utils/weather/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseUrl = 'http://api.weatherapi.com/v1';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getCurrentWeather(String position) async {
    final response = await http
        .get(Uri.parse('$baseUrl/current.json?key=$apiKey&q=$position&aqi=no'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  //Forecast today and tomorrow
  Future<List<WeatherForecast>> getWeatherForecast(String position) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/forecast.json?key=$apiKey&q=$position&days=2&aqi=no&alerts=no'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<WeatherForecast> result = [];

      for (var day in json['forecast']['forecastday']) {
        for (var hour in day['hour']) {
          String time = hour['time'];
          double temperature = hour['temp_c'];
          String condition = hour['condition']['text'];
          String icon = hour['condition']['icon'];

          WeatherForecast newItem = WeatherForecast(
            time: time,
            temperature: temperature,
            condition: condition,
            icon: icon,
          );

          result.add(newItem);
        }
      }
      return result;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentPosition() async {
    //get permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //unused right now
    //convert location into list of placemark objects
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract city name from first placemark
    String currentPosition = '${position.latitude},${position.longitude}';

    return currentPosition;
  }
}
