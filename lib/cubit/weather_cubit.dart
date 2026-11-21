import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository repository;

  final List<String> history = [];

  WeatherCubit(this.repository) : super(WeatherInitial());

  Future<void> loadWeather(String city) async {
    final cityName = city.trim();

    if (cityName.isEmpty) {
      emit(WeatherError('Введите название города'));
      return;
    }

    emit(WeatherLoading());

    try {
      final weather = await repository.getWeather(cityName);

      history.removeWhere(
        (item) => item.toLowerCase() == weather.city.toLowerCase(),
      );

      history.insert(0, weather.city);

      if (history.length > 5) {
        history.removeLast();
      }

      emit(WeatherLoaded(weather, List.from(history)));
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 ||
          error.response?.statusCode == 403) {
        emit(WeatherError('Проверь API-ключ и доступ к API'));
      } else if (error.response?.statusCode == 404) {
        emit(WeatherError('Данные о городе не найдены'));
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        emit(WeatherError('Превышено время ожидания сервера'));
      } else if (error.response?.statusCode == 400) {
        final message = error.response?.data['error'];
        emit(WeatherError(message?.toString() ?? 'Некорректный запрос'));
      } else {
        emit(WeatherError('Не удалось получить погоду. Проверь интернет.'));
      }
    } catch (error) {
      emit(WeatherError(error.toString().replaceFirst('Exception: ', '')));
    }
  }
}
