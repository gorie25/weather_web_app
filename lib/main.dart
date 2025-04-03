import 'package:flutter/material.dart';
import 'package:weather_web_app/features/weather/bloc/history/history_bloc.dart';
import 'package:weather_web_app/features/weather/bloc/weather_bloc/weather_bloc.dart';
import 'package:weather_web_app/features/weather/data/api/api.dart';
import 'package:weather_web_app/features/weather/data/repository/history_repository.dart';
import 'package:weather_web_app/features/weather/presentation/home/homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/weather/data/repository/weather_repository.dart';

Future<void> main() async {
  // Load the .env file
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              WeatherBloc(WeatherRepository(apiService: ApiService())),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(
            historyRepository: HistoryRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          fontFamily: 'Rubik',
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}
