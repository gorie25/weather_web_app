import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_web_app/features/weather/data/repository/history_repository.dart';
import 'package:weather_web_app/features/weather/model/history.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';
part 'history_bloc_event.dart';
part 'history_bloc_state.dart';
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;

  HistoryBloc({required this.historyRepository}) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoadHistory);
    on<AddWeatherToHistory>(_onAddWeatherToHistory);
    on<ClearHistory>(_onClearHistory);
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

  void _onClearHistory(
      ClearHistory event, Emitter<HistoryState> emit) async {
    try {
      await historyRepository.clearHistory();
      emit(HistoryLoaded(HistoryWeather(weatherList: [])));
    } catch (e) {
      emit(HistoryError('Failed to clear history'));
    }
  }
}
