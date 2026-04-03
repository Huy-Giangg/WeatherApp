
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Weather.dart';

class WeatherServices {
  final apiKey = 'ff7b913b7c2943dab9112439262703';


  Future<dynamic> getWeather({required String cityName}) async {
    String url = 'http://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=${cityName}&days=10';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final data = response.body;
      return Weather.fromJson(jsonDecode(data));
    }else{
      return null;
    }
  }

}
