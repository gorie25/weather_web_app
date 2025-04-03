import 'package:weather_web_app/features/weather/data/api/api.dart';
import 'package:weather_web_app/features/weather/model/forecast.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';

class WeatherRepository {
  final ApiService _apiService;

  WeatherRepository({required ApiService apiService})
      : _apiService = apiService;

  Future<WeatherModel> getCurrentWeather(String cityName) async {
    return await _apiService.getCurrentWeather(cityName);
  }

  Future<WeatherModel> getWeatherByCoordinates(
      double latitude, double longitude) async {
    return await _apiService.getWeatherByCoordinates(latitude, longitude);
  }

  Future<Forecast> forecastWeather4days(String cityName) async {
    return await _apiService.getForecastWeather(cityName, days: 5);
  }
}
