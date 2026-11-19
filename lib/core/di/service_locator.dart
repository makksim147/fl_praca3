
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../api_config.dart';
import '../../data/repositories/weather_repository.dart';
import '../../cubit/weather_cubit.dart';
import '../network/api_key_interceptor.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(ApiKeyInterceptor());

  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
    ),
  );

  getIt.registerSingleton<Dio>(dio);

  getIt.registerLazySingleton<WeatherRepository>(
    () => WeatherRepository(getIt<Dio>()),
  );

  getIt.registerFactory<WeatherCubit>(
    () => WeatherCubit(getIt<WeatherRepository>()),
  );
}
