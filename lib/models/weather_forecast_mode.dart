class WeatherForecast {
  final String cityName;
  final double temperatureMin;
  final double temperatureMax;
  final String mainCondition;

  WeatherForecast({
    required this.cityName,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.mainCondition,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      cityName: json['city']['name'],
      temperatureMin: json['list'][0]['main']['temp_min'].toDouble(),
      temperatureMax: json['list'][0]['main']['temp_max'].toDouble(),
      mainCondition: json['list'][0]['weather'][0]['main'],
    );
  }
}
