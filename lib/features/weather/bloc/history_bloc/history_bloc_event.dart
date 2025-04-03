part of 'history_bloc.dart';
abstract class HistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {}

class AddWeatherToHistory extends HistoryEvent {
  final WeatherModel weather;

  AddWeatherToHistory(this.weather);

  @override
  List<Object?> get props => [weather];
}

class ClearHistory extends HistoryEvent {}