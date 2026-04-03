
import 'package:weatherapp/models/WeatherCurrent.dart';
import 'package:weatherapp/models/WeatherHour.dart';

class Weatherfuture extends Weathercurrent{
  final double mintemp_c;
  final double maxtemp_c;

  List<Weatherhour> weatherhours;


  Weatherfuture({
    required super.lastUpdate,
    required super.temp_c,
    required super.desc,
    required super.icon,
    required this.mintemp_c,
    required this.maxtemp_c,
    required this.weatherhours,
  });

  factory Weatherfuture.fromJson(Map<String, dynamic> json){
    return Weatherfuture(
        lastUpdate: DateTime.parse(json['date']),
        temp_c: json['day']['avgtemp_c'].toDouble(),
        desc: json['day']['condition']['text'],
        icon: json['day']['condition']['icon'],
        mintemp_c: json['day']['mintemp_c'].toDouble(),
        maxtemp_c: json['day']['maxtemp_c'].toDouble(),
        weatherhours: (json['hour'] as List)
            .map((hour) => Weatherhour.fromJson(hour))
            .toList(),
    );
  }
}