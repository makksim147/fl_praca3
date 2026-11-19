
import '../data/models/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;
  final List<String> history;

  WeatherLoaded(this.weather, this.history);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}
