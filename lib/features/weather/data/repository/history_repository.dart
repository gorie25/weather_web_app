import 'dart:convert';
import 'package:weather_web_app/features/weather/model/history.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  static const String _key = 'weather_history';

  Future<void> saveWeather(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      String? historyJson = prefs.getString(_key);
      HistoryWeather history;
      if (historyJson != null) {
        history = HistoryWeather.fromJson(json.decode(historyJson));

        bool exists =
            history.weatherList.any((w) => w.cityName == weather.cityName);
        print('City exists in history: $exists');

        if (!exists) {
          history.weatherList.add(weather);
          print('Added new weather to history: ${weather.cityName}');
        }
      } else {
        history = HistoryWeather(
          weatherList: [weather],
        );
      }

      // Lưu lại lịch sử vào SharedPreferences
      final encodedHistory = json.encode(history.toJson());
      await prefs.setString(_key, encodedHistory);
    } catch (e) {
      print('Error while saving weather: $e');
    }
  }

  Future<HistoryWeather?> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_key);

    if (historyJson != null) {
      try {
        final decodedJson = json.decode(historyJson);
        print('Decoded JSON: $decodedJson');
        return HistoryWeather.fromJson(decodedJson);
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('No history found in SharedPreferences.');
    }
    return null;
  }
 Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

}
