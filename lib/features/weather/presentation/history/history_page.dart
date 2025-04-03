import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_web_app/features/weather/bloc/history/history_bloc.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather History'),
        backgroundColor: Colors.blue[600],
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<HistoryBloc>().add(ClearHistory());
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            if (state.history.weatherList.isEmpty) {
              return const Center(child: Text('No history available'));
            }
            return ListView.builder(
              itemCount: state.history.weatherList.length,
              itemBuilder: (context, index) {
                final weather = state.history.weatherList[index];
                return WeatherHistoryCard(weather: weather);
              },
            );
          } else if (state is HistoryError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No history available'));
        },
      ),
    );
  }
}

class WeatherHistoryCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherHistoryCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(weather.date),
        trailing: Text(
          '${weather.temperatureC}°C',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () {
          // context.read<WeatherBloc>().add(FetchWeather(weather.cityName));
          Navigator.pop(context);
        },
      ),
    );
  }
}