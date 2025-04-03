import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_web_app/features/weather/model/forecast.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';

class ApiService {
  late final Dio _dio;
  final String _baseUrl = 'http://api.weatherapi.com/v1/';
  late final String _apiKey;

  // Constructor khởi tạo
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
    ));
    _apiKey = dotenv.get('API_KEY');
  }

  Future<WeatherModel> getCurrentWeather(String cityName) async {
    final queryParams = {
      'key': _apiKey,
      'q': cityName,
    };
    try {
      final response =
          await _dio.get('current.json', queryParameters: queryParams);
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Lỗi API: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('DioException: ${e.response?.statusCode} - ${e.message}');
    }
  }

  Future<WeatherModel> getWeatherByCoordinates(
      double latitude, double longitude) async {
    final queryParams = {
      'key': _apiKey,
      'q': '$latitude,$longitude',
    };
    try {
      final response =
          await _dio.get('current.json', queryParameters: queryParams);
      if (response.statusCode == 200) {
        

        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Lỗi API: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('DioException: ${e.response?.statusCode} - ${e.message}');
    }
  }

  Future<Forecast> getForecastWeather(String cityName, {int days = 5}) async {
    final queryParams = {
      'key': _apiKey,
      'q': cityName,
      'days': days,
    };
    try {
      final response =
          await _dio.get('forecast.json', queryParameters: queryParams);
      if (response.statusCode == 200) {
        final forecast = Forecast.fromJson(response.data);

        if (forecast.forecastday.isNotEmpty) {
          forecast.forecastday.removeAt(0);
        }
        return forecast;
      } else {
        print('Lỗi API: ${response.statusCode}');
        throw Exception('Lỗi API: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode} - ${e.message}');
      throw Exception('DioException: ${e.response?.statusCode} - ${e.message}');
    }
  }
}
