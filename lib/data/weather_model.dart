class WeatherModel {
  final String? cityName;
  final String? weatherDescription;
  final String? weatherIcon;
  final int? temperature;
  final int? feelsLike;
  final int? minTemperature;
  final int? maxTemperature;


  WeatherModel({
    this.cityName,
    this.weatherDescription,
    this.weatherIcon,
    this.temperature,
    this.feelsLike,
    this.minTemperature,
    this.maxTemperature,
  });

factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? "",
      weatherDescription: json['weather'][0]['description'],
      weatherIcon: json['weather'][0]['icon'],
      temperature: json['main']['temp'].round(),
      feelsLike: json['main']['feels_like'].round(),
      minTemperature: json['main']['temp_min'].round(),
      maxTemperature: json['main']['temp_max'].round(),
    );
  }
}