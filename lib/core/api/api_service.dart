import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/features/home/model/weather_model.dart';

class ApiService {
  Future<WeatherModel?> fetchWeather({
    double lat = 48.8567,
    double lon = 2.350,
    String cityName = "Kathmandu",
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://api.weatherapi.com/v1/current.json?key=1bc0383d81444b58b1432929200711&q=$lat,$lon,$cityName",
        ),
      );
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint("exception --- $e");
      return null;
    }
    return null;
  }
}
