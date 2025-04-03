part of 'weather_bloc.dart';

class WeatherBlocEvent {}

class FetchWeather extends WeatherBlocEvent {
  final String city;
  FetchWeather(this.city);
}

class SearchWeather extends WeatherBlocEvent {
  final String city;
  final BuildContext context;
  SearchWeather(this.city, this.context);
}

class FetchWeatherByCurrentCoordinates extends WeatherBlocEvent {
  final double? latitude;
  final double? longitude;
  final BuildContext context;

  FetchWeatherByCurrentCoordinates(this.latitude, this.longitude, this.context);
}

class ForecastWeather4days extends WeatherBlocEvent {
  final String cityName;
  ForecastWeather4days(this.cityName);
}// Add new event
class LoadHistoryWeather extends WeatherBlocEvent {
  @override
  List<Object?> get props => [];
}
