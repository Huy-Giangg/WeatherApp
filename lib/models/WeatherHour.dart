import 'WeatherCurrent.dart';

class Weatherhour extends Weathercurrent{

  Weatherhour({
    required super.lastUpdate,
    required super.temp_c,
    required super.desc,
    required super.icon,
  });

  factory Weatherhour.fromJson(Map<String, dynamic> json){
    return Weatherhour(
      lastUpdate: DateTime.parse(json['time']),
      temp_c: json['temp_c'].toDouble(),
      desc: json['condition']['text'],
      icon: json['condition']['icon'],
    );
  }
}