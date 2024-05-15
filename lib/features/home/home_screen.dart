import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/features/home/service/home_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeService _homeService = HomeService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
      ),
      body: ChangeNotifierProvider(
        create: (context) => HomeService()..getWeather(),
        child: Consumer<HomeService>(
          builder: (context, service, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Temp in C:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: service.isWeatherLoading
                            ? "Loading..."
                            : "${service.weatherModel?.current?.tempC.toString()}",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  service.isWeatherLoading ? "" : service.location.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TextFormField(
                    onChanged: (value) => Provider.of<HomeService>(
                      context,
                      listen: false,
                    ).updateButtonText(value),
                    controller: _homeService.locationController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Location Name',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (service.buttonText == "Update") {
                      service.getWeather(
                        city: _homeService.locationController.text,
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text("You must enter your location"),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Ok"),
                            ),
                          ],
                        ),
                      );
                    }
                    // SharedPreferences sp =
                    //     await SharedPreferences.getInstance();
                    // sp.setString(
                    //   "uniquekey",
                    //   _homeService.locationController.text.trim(),
                    // );
                    // print(sp.getString("uniquekey"));
                    // _homeService.location = sp.getString("uniquekey") ?? "Null";
                    // setState(() {});

                    // saveLocationName(_locationController.text);
                  },
                  child: Text(service.buttonText),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _homeService.getCurrentLocation();
                  },
                  child: const Text("Get current location"),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
