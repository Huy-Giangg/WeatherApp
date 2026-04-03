import 'package:flutter/material.dart';
import 'package:weatherapp/models/Province.dart';
import 'package:weatherapp/models/Weather.dart';
import 'package:weatherapp/models/WeatherCurrent.dart';
import 'package:weatherapp/models/WeatherHour.dart';

import '../constants/sizes.dart';
import '../models/WeatherFuture.dart';
import '../services/province_services.dart';
import '../services/weather_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


class _HomeState extends State<Home> {
  ProvinceServices provinceServices = ProvinceServices();
  WeatherServices weatherServices = WeatherServices();

  Weather? weather;
  Weathercurrent? weathercurrent;
  List<Weatherfuture>? listWeatherfuture;

  List<Province>? listProvinces;


  String selected = 'hai_phong';

  _featchWeather() async {
    try {
      final _weather = await weatherServices.getWeather(cityName: selected);
      setState(() {
        weather = _weather;
        weathercurrent = weather!.weathercurrent;
        listWeatherfuture = weather!.weatherfuture;
      });
    } catch (e) {
      print("Lỗi: $e");
    }
  }


  _featchProvince() async {
    final _province = await provinceServices.getProvince();
    setState(() {
      listProvinces = _province;
      selected = _province.first.codeName;
    });

    _featchWeather();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _featchProvince();
    _featchWeather();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: weather == null
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            weather!.nameCity,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            weathercurrent!.temp_c.toString() + "°",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 60,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            weathercurrent!.desc,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 20),

                          _buildHourlyForecast(),

                          SizedBox(height: 20,),

                          _buildDailyForecast(),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return Container(
      height: 170,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listWeatherfuture![0].weatherhours.length,
        itemBuilder: (context, index) {
          final date = listWeatherfuture![0].weatherhours[index].lastUpdate;
          final icon = listWeatherfuture![0].weatherhours[index].icon;
          final temp = listWeatherfuture![0].weatherhours[index].temp_c;



          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("${date.hour} giờ", style: TextStyle(fontSize: Sizes.fontSize, fontWeight: FontWeight.w500,)),
                  Image.network(getFullIconUrl(icon)),
                  Text("$temp °C", style: TextStyle(fontSize: Sizes.fontSize, fontWeight: FontWeight.w500,))
                ],
              )
          );
        },
      ),
    );
  }

  Widget _buildDailyForecast() {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: Sizes.fontSize),
              SizedBox(width: 10,),
              Text("Dự báo 10 ngày", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, ),),
            ],
          ),
          const Divider(color: Colors.black),
          Container(
            height: 300,
            child: ListView.builder(
                shrinkWrap: true, // Thêm dòng này

              itemCount: listWeatherfuture!.length,
              itemBuilder: (context, index) {
                final date = listWeatherfuture![index].lastUpdate;
                final icon = listWeatherfuture![index].icon;
                final temp = listWeatherfuture![index].temp_c;
                final mintemp = listWeatherfuture![index].mintemp_c;
                final maxtemp = listWeatherfuture![index].maxtemp_c;


                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 50,
                        child: Text("${date.day}/${date.month}", style: TextStyle(fontSize: Sizes.fontSize, fontWeight: FontWeight.w500,),)
                    ),
                    Image.network(getFullIconUrl(icon)),
                    //Text("$temp °C", style: TextStyle(fontSize: Sizes.fontSize, fontWeight: FontWeight.w500,)),
                    Expanded(child: tempProgess(mintemp, temp, maxtemp)),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget tempProgess(double min, double avg, double max) {
    // Tránh chia cho 0 nếu min == max
    double percent = (max - min) == 0 ? 0.5 : (avg - min) / (max - min);

    return Row(
      children: [
        Text("${min.round()}°", style: TextStyle(fontSize: Sizes.fontSize, fontWeight: FontWeight.w500,)),
        Expanded( // Chiếm không gian ở giữa
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Bạn có thể vẽ một thanh màu ở đây nếu muốn
                Align(
                  alignment: Alignment(percent * 2 - 1, 0), // Căn chỉnh chấm trắng
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.blue, // Đổi màu cho dễ nhìn
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Text("${max.round()}°", style: TextStyle(fontSize: Sizes.fontSize, fontWeight: FontWeight.w500,)),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: DropdownButtonHideUnderline(
        child: DropdownButton(
          hint: Text("Chọn tỉnh/thành phố"),
            value: (listProvinces != null &&
                listProvinces!.any((p) => p.codeName == selected))
                ? selected
                : null,
            icon: const Icon(Icons.arrow_drop_down),
            items: (listProvinces ?? []).map((province) {
              return DropdownMenuItem<String>(
                value: province.codeName,
                child: Text(province.name),
              );
            }).toList(),
            onChanged: (value){
              setState(() {
                selected = value!;
              });
              _featchWeather();
            }
        ),
      ),
    );
  }


  String getFullIconUrl(String icon) {
    return "https:$icon";
  }
}
