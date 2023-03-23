import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app_mway/config/routs_names.dart';
import 'package:weather_app_mway/data/weather_model.dart';
import 'package:weather_app_mway/presentation/current_weather_screen.dart';
import 'package:weather_app_mway/presentation/forecast_screen.dart';

class AppRouter {
  AppRouter();
  late final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          name: kCurrentWeather,
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const CurrentWeatherScreen();
          },
          routes: [
            GoRoute(
                name: kForecastWeather,
                path: 'forecast-weather/:id',
                builder: (BuildContext context, GoRouterState state) {
                  return ForecastScreen(
                      cityName: state.queryParams['cityName'], weather: state.extra as WeatherModel);
                }),
          ]),
    ],
  );
}
