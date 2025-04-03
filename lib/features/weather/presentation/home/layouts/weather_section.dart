import 'package:flutter/material.dart';
import 'package:weather_web_app/features/weather/model/forecast.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';
import 'package:weather_web_app/features/weather/presentation/home/layouts/forecast_card.dart';
import 'package:weather_web_app/features/weather/utils/constants.dart';

class WeatherSection extends StatelessWidget {
  final WeatherModel weatherData;
  final Forecast forecastData;
  const WeatherSection(
      {super.key, required this.weatherData, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 4,
            color: Colors.blue[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            weatherData!.cityName,
                            style: TextStyle(
                              fontSize: AppConstants.fontCity(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            ' (${weatherData!.date})',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Temperature: ${weatherData?.temperatureC} °C',
                        style: TextStyle(
                          fontSize: AppConstants.fontDetail(context),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Wind: ${weatherData?.wind} M/S',
                        style: TextStyle(
                          fontSize: AppConstants.fontDetail(context),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Humidity: ${weatherData?.humidity} %',
                        style: TextStyle(
                          fontSize:AppConstants.fontDetail(context),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Column( 
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: AppConstants.sizeIcon(context),
                        height: AppConstants.sizeIcon(context),
                        child: Image.network(
                          weatherData!.iconUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        '${weatherData?.condition}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '4-Day Forecast',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: ForecastCard(forecasts: forecastData),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
