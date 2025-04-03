part of 'weather_bloc.dart';

abstract class WeatherBlocState extends Equatable {
  const WeatherBlocState();

  @override
  List<Object?> get props => [];

  get weatherData => null;
  get forecastData => null;
}

class WeatherInitial extends WeatherBlocState {}

class WeatherLoading extends WeatherBlocState {}

class WeatherLoaded extends WeatherBlocState {
  final WeatherModel? weatherData;
  final Forecast? forecastData;
  const WeatherLoaded(this.weatherData, this.forecastData);

  @override
  List<Object?> get props => [weatherData];
}

class WeatherError extends WeatherBlocState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchSuccess extends WeatherBlocState {
  final WeatherModel weatherData;
  final Forecast? forecastData;
  const SearchSuccess(this.weatherData, this.forecastData);

  @override
  List<Object?> get props => [weatherData];
}

class SearchFailure extends WeatherBlocState {}


// Add new state
class HistoryLoaded extends WeatherBlocState {
  final HistoryWeather history;

  HistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}