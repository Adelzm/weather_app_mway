import 'package:flutter/material.dart';
import 'package:weather_app_mway/config/app_rounter.dart';

class MWayWeatherApp extends StatelessWidget {
  const MWayWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MWay Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFFD966))
      ).copyWith(useMaterial3: true),
      routerConfig: AppRouter().router,
    );
  }
}
