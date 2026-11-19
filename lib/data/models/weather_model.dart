
class WeatherModel {
  final String city;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int cloudPct;
  final double minTemp;
  final double maxTemp;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.cloudPct,
    required this.minTemp,
    required this.maxTemp,
  });

  factory WeatherModel.fromJson(
    String city,
    Map<String, dynamic> json,
  ) {
    return WeatherModel(
      city: city,
      temperature: (json['temp'] as num).toDouble(),
      feelsLike: (json['feels_like'] as num).toDouble(),
      humidity: (json['humidity'] as num).toInt(),
      windSpeed: (json['wind_speed'] as num).toDouble(),
      cloudPct: (json['cloud_pct'] as num).toInt(),
      minTemp: (json['min_temp'] as num).toDouble(),
      maxTemp: (json['max_temp'] as num).toDouble(),
    );
  }
}
