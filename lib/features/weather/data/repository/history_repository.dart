import 'dart:convert';
import 'package:weather_web_app/features/weather/model/history.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryRepository {
  static const String _key = 'weather_history';

  Future<void> saveWeather(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Lấy lịch sử hiện tại
      String? historyJson = prefs.getString(_key);
      print('Current history JSON: $historyJson');

      HistoryWeather history;

      if (historyJson != null) {
        // Giải mã JSON thành đối tượng HistoryWeather
        history = HistoryWeather.fromJson(json.decode(historyJson));
        print('Decoded history: ${history.weatherList}');

        bool exists =
            history.weatherList.any((w) => w.cityName == weather.cityName);
        print('City exists in history: $exists');

        if (!exists) {
          history.weatherList.add(weather);
          print('Added new weather to history: ${weather.cityName}');
        } else {
          print('City already exists in history: ${weather.cityName}');
        }
      } else {
        // Nếu không có lịch sử, tạo mới
        history = HistoryWeather(
          weatherList: [weather],
        );
        print('Created new history with city: ${weather.cityName}');
      }

      // Lưu lại lịch sử vào SharedPreferences
      final encodedHistory = json.encode(history.toJson());
      print('Encoded history JSON: $encodedHistory');
      await prefs.setString(_key, encodedHistory);
      print('History saved successfully.');
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

  /// Hàm kiểm tra xem một thành phố đã tồn tại trong lịch sử hay chưa
  Future<bool> isCityInHistory(String cityName) async {
    final history = await getHistory();
    if (history != null) {
      return history.weatherList.any((weather) => weather.cityName == cityName);
    }
    return false;
  }
}
