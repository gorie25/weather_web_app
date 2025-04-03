import 'package:weather_web_app/features/weather/model/weather.dart';

class HistoryWeather {
  final List<WeatherModel> weatherList;

  HistoryWeather({
    required this.weatherList,
  });

  factory HistoryWeather.fromJson(Map<String, dynamic> json) {
    var list = json['weatherList'] as List;
    List<WeatherModel> weatherHistoryList = list.map((i) {
      // Giải mã từng phần tử mà không sử dụng fromJson của WeatherModel
      return WeatherModel(
        cityName: i['cityName'],
        condition: i['condition'],
        iconUrl: i['iconUrl'],
        temperatureC: i['temperature'],
        wind: i['wind'],
        humidity: i['humidity'],
        date: i['date'],
        feelsLikeC: null,
        windDirection: '',
        pressureMb: null,
      );
    }).toList();

    return HistoryWeather(weatherList: weatherHistoryList);
  }

  Map<String, dynamic> toJson() {
    return {
      'weatherList': weatherList.map((weather) => weather.toJson()).toList(),
    };
  }
}
