import 'dart:convert';

import 'package:fitgap/src/features/home/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseUrl = 'http://api.weatherapi.com/v1';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getCurrentWeather(String position) async {
    final response = await http
        .get(Uri.parse('$baseUrl/current.json?key=$apiKey&q=$position'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
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

    //convert location into list of placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //extract city name from first placemark
    String currentPosition = '${position.latitude},${position.longitude}';
    print(placemarks.first.locality);
    print(currentPosition);

    return currentPosition;
  }
}
