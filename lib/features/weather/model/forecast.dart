class Forecast {
  List<ForecastDay> forecastday;

  Forecast({required this.forecastday});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var list = json['forecast']['forecastday'] as List?;

    if (list == null) {
      return Forecast(forecastday: []);
    }

    List<ForecastDay> forecastList =
        list.map((item) => ForecastDay.fromJson(item)).toList();

    return Forecast(forecastday: forecastList);
  }

  @override
  String toString() {
    return 'Forecast(forecastday: $forecastday)';
  }
}

class ForecastDay {
  String date;
  double tempC;
  double windMph;
  int humidity;
  String conditionIcon;
  String conditionText;

  ForecastDay({
    required this.date,
    required this.tempC,
    required this.windMph,
    required this.humidity,
    required this.conditionIcon,
    required this.conditionText,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      tempC: json['day']['avgtemp_c'],
      windMph: json['day']['maxwind_mph'],
      humidity: json['day']['avghumidity'],
      conditionIcon: json['day']['condition']['icon'],
      conditionText: json['day']['condition']['text'],
    );
  }

  @override
  String toString() {
    return '(date: $date, tempC: $tempC, windMph: $windMph, humidity: $humidity, conditionIcon: $conditionIcon, conditionText: $conditionText)';
  }
}