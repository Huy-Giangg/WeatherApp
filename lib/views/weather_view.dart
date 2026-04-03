import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapp/models/Province.dart';

import '../models/Weather.dart';
import '../services/province_services.dart';
import '../services/weather_services.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  WeatherServices weatherServices = WeatherServices();
  ProvinceServices provinceServices = ProvinceServices();
  Weather? weather;

  // 1. Khởi tạo giá trị mặc định phải nằm trong danh sách quốc gia
  String? selected;

  List<Province> listProvince = [];

  _fetchWeather(String cityName) async {
    try {
      final _weather = await weatherServices.getWeather(cityName: cityName);
      setState(() {
        weather = _weather;
        // Đừng cập nhật selectedCountry bằng weather.nameCity ở đây
        // vì nameCity có thể là 'Hanoi', không khớp với danh sách Quốc gia.
      });
    } catch (e) {
      print("Lỗi: $e");
    }
  }

  void loadProvince() async {
    final data = await provinceServices.getProvince();
    setState(() {
      listProvince = data;
      selected = data[0].codeName;
    });

    _fetchWeather(selected!);
  }

  @override
  void initState() {
    super.initState();
    loadProvince();
  }

  // Hàm này nên nhận String? để an toàn hơn
  String getWeatherIcon(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. Thêm màu nền tối để nhìn rõ Dropdown màu trắng
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: weather == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCountryDropdown(),
                  const SizedBox(height: 20),
                  Text(
                    weather!.nameCity,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  // Tăng kích thước Lottie cho đẹp
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: Lottie.asset(
                      getWeatherIcon(weather?.weathercurrent.desc),
                    ),
                  ),
                  Text(
                    '${weather!.weathercurrent.temp_c.round()}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

    Widget _buildCountryDropdown() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white24),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: listProvince.any((p) => p.codeName == selected)
                ? selected
                : null,
            menuMaxHeight: 300,
            icon: const Icon(Icons.expand_more, color: Colors.white),
            dropdownColor: Colors.blueGrey[800],
            isExpanded: true,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selected = newValue;
                });
                _fetchWeather(newValue);
              }
            },
            items: listProvince.map((province) {
              return DropdownMenuItem<String>(
                value: province.codeName,
                child: Text(province.name),
              );
            }).toList(),
          ),
        ),
      );
    }
}
