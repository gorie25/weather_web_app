import 'package:flutter/material.dart';
import 'package:weather_web_app/features/weather/bloc/history/history_bloc.dart';
import 'package:weather_web_app/features/weather/bloc/weather_bloc/weather_bloc.dart';
import 'package:weather_web_app/features/weather/model/forecast.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';
import 'package:weather_web_app/features/weather/presentation/history/history_page.dart';
import 'package:weather_web_app/features/weather/presentation/home/layouts/weather_section.dart';
import 'package:weather_web_app/features/weather/presentation/home/layouts/search_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  // Phương thức bất đồng bộ để lấy dữ liệu từ SharedPreferences
  Future<void> _initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Thành phố được lưu là: ${prefs.getString('lastCity')}');
    String lastCity = prefs.getString('lastCity') ?? "Hanoi"; //
    context.read<WeatherBloc>().add(FetchWeather(lastCity));
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        centerTitle: true,
        title: const Text(
          'Weather Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 184, 224, 244),
        child: SafeArea(
          child: BlocBuilder<WeatherBloc, WeatherBlocState>(
            builder: (context, state) {
              print(state);
              if (state is WeatherLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is WeatherError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                );
              } else if (state is WeatherLoaded ||
                  state is SearchSuccess ||
                  state is SearchFailure) {
                context
                    .read<HistoryBloc>()
                    .add(AddWeatherToHistory(state.weatherData));

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: isMobile
                      ? VerticalLayout() // Mobile layout
                      : HorizontalLayout(), // Desktop layout
                );
              }
              //
              return const Center(
                child: Text(
                  'Enter a city to fetch weather data',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Vertical layout for mobile
  Widget VerticalLayout() {
    final weather = context.read<WeatherBloc>().state.weatherData;
    final forecast = context.read<WeatherBloc>().state.forecastData;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchSection(),
          const SizedBox(height: 16),
          WeatherSection(weatherData: weather, forecastData: forecast),
        ],
      ),
    );
  }

  // Horizontal layout for larger screens
  Widget HorizontalLayout() {
    final weather = context.read<WeatherBloc>().state.weatherData;
    final forecast = context.read<WeatherBloc>().state.forecastData;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: SearchSection()),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: WeatherSection(weatherData: weather, forecastData: forecast),
        ),
      ],
    );
  }
}
