
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/Province.dart';

class ProvinceServices {
  final String url = 'https://provinces.open-api.vn/api/v1/p/';
  
  Future<List<Province>> getProvince() async {
    final response = await http.get(Uri.parse(url));
    
    if(response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((e) => Province.fromJson(e)).toList();
    }else {
      throw Exception('Failed to load provinces');
    }
  }
}