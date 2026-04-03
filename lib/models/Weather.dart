
import 'package:weatherapp/models/WeatherCurrent.dart';
import 'package:weatherapp/models/WeatherFuture.dart';

class Weather {
  final String nameCity;
  final Weathercurrent weathercurrent;
  final List<Weatherfuture> weatherfuture;

  Weather({
    required this.nameCity,
    required this.weathercurrent,
    required this.weatherfuture,
  });

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
        nameCity: json['location']['name'],
        weathercurrent: Weathercurrent.fromJson(json['current']),
        weatherfuture: (json['forecast']['forecastday'] as List)
            .map((day) => Weatherfuture.fromJson(day))
            .toList(),
    );
  }


}