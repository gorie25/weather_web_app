import 'package:weather_web_app/features/weather/model/weather.dart';

class HistoryWeather {
  final List<WeatherModel> weatherList;

  HistoryWeather({
    required this.weatherList,
  });

  factory HistoryWeather.fromJson(Map<String, dynamic> json) {
    var list = json['weatherList'] as List;
    List<WeatherModel> weatherHistoryList = list.map((i) {
      return WeatherModel(
        cityName: i['cityName'],
        condition: i['condition'],
        iconUrl: i['iconUrl'],
        temperatureC: i['temperature'],
        wind: i['wind'],
        humidity: i['humidity'],
        date: i['date'],

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
