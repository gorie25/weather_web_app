import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_web_app/features/weather/data/repository/history_repository.dart';
import 'package:weather_web_app/features/weather/model/history.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';

// Events
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

// States
abstract class HistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final HistoryWeather history;

  HistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;

  HistoryBloc({required this.historyRepository}) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<AddWeatherToHistory>(_onAddWeatherToHistory);
  }

  void _onLoadHistory(LoadHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      print('Loading history...');
      final history = await historyRepository.getHistory();
      print('History loaded: $history');
      if (history == null) {
        print('History is null');
      } else {
        print('History is not null: ${history.weatherList}');
      }
      if (history != null) {
        emit(HistoryLoaded(history));
      } else {
        emit(HistoryLoaded(HistoryWeather(weatherList: [])));
      }
    } catch (e) {
      print(e);
      emit(HistoryError('Failed to load history'));
    }
  }

  void _onAddWeatherToHistory(
      AddWeatherToHistory event, Emitter<HistoryState> emit) async {
    try {
      await historyRepository.saveWeather(event.weather);
      final history = await historyRepository.getHistory();
      if (history != null) {
        emit(HistoryLoaded(history));
      }
    } catch (e) {
      emit(HistoryError('Failed to add weather to history'));
    }
  }


}