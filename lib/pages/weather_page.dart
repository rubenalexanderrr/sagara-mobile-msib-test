import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/pages/weather_forecast_page.dart';
import 'package:weatherapp/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService =
      WeatherService(apiKey: '1f00722e272da830c15adaf6979a1c11');
  Weather? _weather;
  bool _isLoading = true;

  // fetch weather
  _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position position = await _weatherService.getCurrentPosition();
      double lat = position.latitude;
      double lon = position.longitude;

      final weather = await _weatherService.getWeather(lat, lon);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloudy.json';
      case 'mist':
      case 'smoke':
        return 'assets/cloudy.json';
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/stormy.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 65, 86, 95),
        title: const Text("Weather App"),
        titleTextStyle: const TextStyle(
          color: Colors.white60,
          fontSize: 24,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          letterSpacing: 10,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 65, 86, 95),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weather?.cityName ?? "City",
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                  const SizedBox(height: 20),
                  Text(
                    '${_weather?.temperature.round() ?? 0}°C',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    _weather?.mainCondition ?? 'Weather Condition',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WeatherForecastPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Click for Forecast!',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
