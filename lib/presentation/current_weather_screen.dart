import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app_mway/config/routs_names.dart';
import 'package:weather_app_mway/data/geolocator_services.dart';
import 'package:weather_app_mway/data/weather_data_source.dart';
import 'package:weather_app_mway/data/weather_model.dart';

enum DataStatus { done, loading, error }

class CurrentWeatherScreen extends StatefulWidget {
  const CurrentWeatherScreen({super.key});

  @override
  State<CurrentWeatherScreen> createState() => _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends State<CurrentWeatherScreen> {
  final WeatherDataSource _weatherDataSource = WeatherDataSource();
  final GeolocatorService _geolocatorService = GeolocatorService();
  WeatherModel? _currentWeather;
  List<WeatherModel>? _fiveDaysForecast;
  DataStatus _currentStatus = DataStatus.loading;
  DataStatus _forecastStatus = DataStatus.loading;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    getWeatherData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> getCurrentWeather(double lat, double lon) async {
    var currentWeather = await _weatherDataSource.getCurrentWeather(lat, lon);
    if (currentWeather == null) {
      setState(() {
        _currentStatus = DataStatus.error;
      });
    }
    setState(() {
      _currentWeather = currentWeather;
      setState(() => _currentStatus = DataStatus.done);
    });
  }

  Future<void> getCurrentWeatherByName(String cityName) async {
    var currentWeather = await _weatherDataSource.getWeatherByCityName(cityName);
    if (currentWeather == null) {
      setState(() {
        _currentStatus = DataStatus.error;
      });
    }
    setState(() {
      _currentWeather = currentWeather;
      setState(() => _currentStatus = DataStatus.done);
    });
  }

  Future<void> getFiveDaysForecast(double lat, double lon) async {
    List<WeatherModel>? fiveDaysForecast = await _weatherDataSource.getFiveDaysForecast(lat, lon);
    if (fiveDaysForecast == null) {
      setState(() {
        _forecastStatus = DataStatus.error;
      });
    }
    setState(() {
      _fiveDaysForecast = fiveDaysForecast;
      setState(() => _forecastStatus = DataStatus.done);
    });
  }

  Future<void> getFiveDaysForecastByName(String cityName) async {
    List<WeatherModel>? fiveDaysForecast =
        await _weatherDataSource.getFiveDaysForecastByName(cityName);
    if (fiveDaysForecast == null) {
      setState(() {
        _forecastStatus = DataStatus.error;
      });
    }
    setState(() {
      _fiveDaysForecast = fiveDaysForecast;
      setState(() => _forecastStatus = DataStatus.done);
    });
  }

  Future<void> getWeatherData() async {
    var currentPosition = await _geolocatorService.getCurrentLocation();

    if (currentPosition == null) {
      setState(() => _currentStatus = DataStatus.error);
      setState(() => _forecastStatus = DataStatus.error);
    } else {
      setState(() => _currentStatus = DataStatus.loading);
      setState(() => _forecastStatus = DataStatus.loading);
      getCurrentWeather(currentPosition.latitude, currentPosition.longitude);
      getFiveDaysForecast(currentPosition.latitude, currentPosition.longitude);
    }
  }

  Future<void> getWeatherDataByName(String cityName) async {
    setState(() => _currentStatus = DataStatus.loading);
    setState(() => _forecastStatus = DataStatus.loading);
    getCurrentWeatherByName(cityName);
    getFiveDaysForecastByName(cityName);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStatus == DataStatus.loading || _forecastStatus == DataStatus.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_currentStatus == DataStatus.done && _forecastStatus == DataStatus.done) {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            getWeatherData();
            _controller.clear();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter city name',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          getWeatherDataByName(_controller.value.text);
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CachedNetworkImage(
                    imageUrl:
                        'https://openweathermap.org/img/wn/${_currentWeather?.weatherIcon}@4x.png',
                    placeholder: (context, url) => Container(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ).animate().shake(duration: const Duration(milliseconds: 600)),
                  Text(_currentWeather?.cityName ?? 'No city name',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${_currentWeather?.temperature.toString()} °C'),
                      const SizedBox(width: 12),
                      Text(_currentWeather?.weatherDescription ?? 'No weather description'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _textButtonsList(_fiveDaysForecast!, _currentWeather!.cityName!),
                  ),
                  const Spacer(),
                ]),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Something went wrong!'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStatus = DataStatus.loading;
                  _forecastStatus = DataStatus.loading;
                });
                getWeatherData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _textButtonsList(List<WeatherModel> forecastList, String cityName) {
    List<Widget> list = [];
    for (var i = 0; i < 5; i++) {
      list.add(
        TemperatureButton(weather: forecastList[i], cityName: cityName, id: i),
      );
    }
    return list;
  }
}

class TemperatureButton extends StatelessWidget {
  const TemperatureButton(
      {super.key, required this.weather, required this.cityName, required this.id});
  final int id;
  final String cityName;
  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          context.goNamed(kForecastWeather,
              queryParams: {'cityName': cityName}, params: {'id': id.toString()}, extra: weather);
        },
        child: Text('${weather.temperature}°C'));
  }
}
