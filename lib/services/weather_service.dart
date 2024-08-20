import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/models/weather_forecast_mode.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5';
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load weather data ${response.statusCode} ${response.body}');
    }
  }

  Future<Position> getCurrentPosition() async {
    //get permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // get current location data
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<WeatherForecast> getPredictedWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL/forecast?lat=$lat&lon=$lon&cnt{3}&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to load weather data ${response.statusCode} ${response.body}');
    }
  }
}
