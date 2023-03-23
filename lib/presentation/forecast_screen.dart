import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_app_mway/data/weather_model.dart';

enum DataStatus { done, loading, error }

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key, required this.cityName, required this.weather});

  final String? cityName;
  final WeatherModel weather;

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CachedNetworkImage(
            imageUrl: 'https://openweathermap.org/img/wn/${widget.weather.weatherIcon}@4x.png',
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ).animate().shake(duration: const Duration(milliseconds: 600)),
          Text(widget.cityName ?? "No City Name", style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${widget.weather.temperature.toString()} °C'),
              const SizedBox(width: 12),
              Text(widget.weather.weatherDescription ?? 'No weather description'),
            ],
          ),
        ]),
      ),
    );
  }
}
