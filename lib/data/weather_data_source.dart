import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:weather_app_mway/data/weather_model.dart';

class WeatherDataSource {
  final String _apiKey = 'dbc995d680273bbf29ce2b6de0ac8dab';
  final String _units = 'metric';

  Future<WeatherModel?> getCurrentWeather(double lat, double lon) async {
    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=$_units');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body);
        WeatherModel weather = WeatherModel.fromJson(json);
        return weather;
      } else {
        Exception('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      Exception(e.toString());
      return null;
    }
  }

  Future<List<WeatherModel>?> getFiveDaysForecast(double lat, double lon) async {
    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=$_units');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body);
        var jsonList = json['list'] as List;
        List<WeatherModel> weatherList =
            jsonList.map((weather) => WeatherModel.fromJson(weather)).toList();
        return weatherList;
      } else {
        Exception('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('------ Exception ------');
      print(e.toString());
      return null;
    }
  }

   Future<WeatherModel?> getWeatherByCityName(String cityName) async {
    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$_apiKey&units=$_units');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body);
        WeatherModel weather = WeatherModel.fromJson(json);
        return weather;
      } else {
        Exception('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      Exception(e.toString());
      return null;
    }
  }

   Future<List<WeatherModel>?> getFiveDaysForecastByName(String cityName) async {
    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$_apiKey&units=$_units');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body);
        var jsonList = json['list'] as List;
        List<WeatherModel> weatherList =
            jsonList.map((weather) => WeatherModel.fromJson(weather)).toList();
        return weatherList;
      } else {
        Exception('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('------ Exception ------');
      print(e.toString());
      return null;
    }
  }
}
