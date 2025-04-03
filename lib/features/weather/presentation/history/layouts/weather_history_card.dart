import 'package:flutter/material.dart';
import 'package:weather_web_app/features/weather/model/weather.dart';
import 'package:weather_web_app/features/weather/utils/constants.dart';

class WeatherHistoryCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherHistoryCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
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
                        weather!.cityName,
                        style: TextStyle(
                          fontSize: AppConstants.fontCity(context),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ' (${weather.date})',
                        style: TextStyle(
                          fontSize: AppConstants.fontDetail(context),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Temperature: ${weather.temperatureC} °C',
                    style: TextStyle(
                      fontSize: AppConstants.fontDetail(context),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Wind: ${weather.wind} M/S',
                    style: TextStyle(
                      fontSize: AppConstants.fontDetail(context),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Humidity: ${weather.humidity} %',
                    style: TextStyle(
                      fontSize: AppConstants.fontDetail(context),
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
                      weather.iconUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    '${weather.condition}',
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
    );
  }
}
