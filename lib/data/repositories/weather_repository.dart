
import 'package:dio/dio.dart';

import '../models/weather_model.dart';

class WeatherRepository {
  final Dio dio;

  WeatherRepository(this.dio);

  Future<WeatherModel> getWeather(String city) async {
    final cityResponse = await dio.get(
      '/city',
      queryParameters: {
        'name': city,
      },
    );

    final cities = cityResponse.data as List<dynamic>;

    if (cities.isEmpty) {
      throw Exception('Город не найден');
    }

    final cityData = cities.first as Map<String, dynamic>;

    final latitude = cityData['latitude'];
    final longitude = cityData['longitude'];

    final weatherResponse = await dio.get(
      '/weather',
      queryParameters: {
        'lat': latitude,
        'lon': longitude,
      },
    );

    final weatherData =
        weatherResponse.data as Map<String, dynamic>;

    final cityName = cityData['name'] as String? ?? city;

    return WeatherModel.fromJson(cityName, weatherData);
  }
}
