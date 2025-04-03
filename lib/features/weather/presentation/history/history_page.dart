import 'package:flutter/material.dart';
import 'package:weather_web_app/features/weather/bloc/history_bloc/history_bloc.dart';
import 'package:weather_web_app/features/weather/presentation/history/layouts/weather_history_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
        title: const Text(
          'Weather History',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[600],
        iconTheme: const IconThemeData(
          color: Colors.white, // Màu sắc của biểu tượng
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<HistoryBloc>().add(ClearHistory());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HistoryLoaded) {
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
      ),
    );
  }
}
