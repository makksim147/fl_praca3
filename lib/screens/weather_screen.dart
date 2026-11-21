import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/weather_cubit.dart';
import '../cubit/weather_state.dart';
import '../data/models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _controller = TextEditingController();

  String currentCity = 'Moscow';

  @override
  void initState() {
    super.initState();
    context.read<WeatherCubit>().loadWeather(currentCity);
  }

  void searchWeather() {
    String city = _controller.text.trim();

    if (city.isNotEmpty) {
      currentCity = city;
      context.read<WeatherCubit>().loadWeather(city);
    }
  }

  void refreshWeather() {
    context.read<WeatherCubit>().loadWeather(currentCity);
  }

  void selectCity(String city) {
    _controller.text = city;
    currentCity = city;
    context.read<WeatherCubit>().loadWeather(city);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildWeatherInfo(WeatherModel weather) {
    return Column(
      children: [
        const SizedBox(height: 20),

        const Icon(
          Icons.cloud,
          size: 65,
          color: Colors.blue,
        ),

        const SizedBox(height: 10),

        Text(
          weather.city,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          '${weather.temperature.toStringAsFixed(1)} °C',
          style: const TextStyle(
            fontSize: 40,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Ощущается как ${weather.feelsLike.toStringAsFixed(1)} °C',
        ),

        const SizedBox(height: 25),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.water_drop),
          title: const Text('Влажность'),
          trailing: Text('${weather.humidity}%'),
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.air),
          title: const Text('Скорость ветра'),
          trailing: Text(
            '${weather.windSpeed.toStringAsFixed(1)} м/с',
          ),
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.cloud),
          title: const Text('Облачность'),
          trailing: Text('${weather.cloudPct}%'),
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.thermostat),
          title: const Text('Минимальная температура'),
          trailing: Text(
            '${weather.minTemp.toStringAsFixed(1)} °C',
          ),
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.thermostat),
          title: const Text('Максимальная температура'),
          trailing: Text(
            '${weather.maxTemp.toStringAsFixed(1)} °C',
          ),
        ),

        const Divider(),
      ],
    );
  }

  Widget buildHistory(List<String> history) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        const Text(
          'История поиска',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        for (String city in history)
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(city),
            onTap: () {
              selectCity(city);
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: refreshWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Название города',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                searchWeather();
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: searchWeather,
              child: const Text('Найти погоду'),
            ),

            const SizedBox(height: 20),

            BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const CircularProgressIndicator();
                }

                if (state is WeatherError) {
                  return Column(
                    children: [
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: refreshWeather,
                        child: const Text('Повторить'),
                      ),
                    ],
                  );
                }

                if (state is WeatherLoaded) {
                  return Column(
                    children: [
                      buildWeatherInfo(state.weather),
                      buildHistory(state.history),
                    ],
                  );
                }

                return const Text(
                  'Введите название города',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
