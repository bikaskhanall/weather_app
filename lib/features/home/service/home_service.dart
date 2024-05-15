import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/api/api_service.dart';
import 'package:weather_app/features/home/model/weather_model.dart';

class HomeService extends ChangeNotifier {
  String buttonText = "Save";
  final ApiService _api = ApiService();
  WeatherModel? weatherModel;
  String location = "";
  bool isWeatherLoading = false;

  void updateButtonText(String value) {
    buttonText = value.isEmpty ? "Save" : "Update";
    notifyListeners();
  }

  void getWeather({String? city}) async {
    isWeatherLoading = true;
    weatherModel = await _api.fetchWeather(cityName: city ?? "");
    if (weatherModel != null) {
      var address = weatherModel?.location;
      getAddress("Location: ${address?.name} ${address?.tzId}");
    }
    isWeatherLoading = false;
    notifyListeners();
  }

  void getAddress(String value) {
    location = value;
    notifyListeners();
  }

  final locationController = TextEditingController();
  String locationMessage = 'Current location';
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location service are disabled");
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location permission are denied forever ,we cant request");
    }
    return await Geolocator.getCurrentPosition();
  }
}
