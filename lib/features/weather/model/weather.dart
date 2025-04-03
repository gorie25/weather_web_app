import 'dart:convert';

class WeatherModel {
  final String cityName;
  final String condition;
  final String iconUrl;
  final double temperatureC;
  final double? feelsLikeC;
  final double wind;
  final double humidity;
  final String? windDirection;
  final double? pressureMb;
  final String date; // Thêm trường ngày

  WeatherModel({
    required this.cityName,
    required this.condition,
    required this.iconUrl,
    required this.temperatureC,
    required this.feelsLikeC,
    required this.wind,
    required this.humidity,
    required this.windDirection,
    required this.pressureMb,
    required this.date, // Thêm ngày vào constructor
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    String localtime = json['location']['localtime'];
    String date = localtime.split(' ')[0];

    String cityName =
        utf8.decode(json['location']['name'].toString().codeUnits);

    return WeatherModel(
      cityName: cityName,
      condition: json['current']['condition']['text'],
      iconUrl: 'https:' + json['current']['condition']['icon'],
      temperatureC: json['current']['temp_c'],
      feelsLikeC: json['current']['feelslike_c'],
      wind: json['current']['wind_kph'],
      humidity: json['current']['humidity'],
      windDirection: json['current']['wind_dir'],
      pressureMb: json['current']['pressure_mb'],
      date: date, // Gán giá trị ngày
    );
  }

  @override
  String toString() {
    return 'Weather in $cityName: $condition, Temp: ${temperatureC}°C, Feels like: ${feelsLikeC}°C, Wind: $wind kph, Humidity: $humidity%, Pressure: $pressureMb mb, Date: $date';
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'condition': condition,
      'localtime': date,
      'iconUrl': iconUrl,
      'temperature': temperatureC,
      'wind': wind,
      'humidity': humidity,
    };
  }
}
