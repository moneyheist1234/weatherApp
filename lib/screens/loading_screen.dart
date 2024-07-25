import 'package:flutter/material.dart';
import 'package:geotest/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geotest/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String locationMessage = "Fetching location...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocationData();
    // Add a timeout
    Future.delayed(Duration(seconds: 60), () {
      if (mounted && isLoading) {
        setState(() {
          locationMessage = "Loading took too long. Please try again.";
          isLoading = false;
        });
      }
    });
  }

  Future<void> getLocationData() async {
    try {
      print("Starting to fetch weather data");
      WeatherModel weatherModel = WeatherModel();
      var weatherData = await weatherModel.getLocationWeather().timeout(
        Duration(seconds: 30),
        onTimeout: () {
          setState(() {
            locationMessage = "Timeout: Unable to fetch weather data";
            isLoading = false;
          });
          return null;
        },
      );
      print("Weather data received: $weatherData");

      if (weatherData != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LocationScreen(
            locationWeather: weatherData,
          );
        }));
      } else {
        setState(() {
          locationMessage = "Unable to fetch weather data";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error occurred: $e");
      setState(() {
        locationMessage = "Error: ${e.toString()}";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SpinKitWaveSpinner(
                    color: Colors.white38,
                    size: 75.0,
                    trackColor: Colors.white38.withOpacity(0.01),
                    waveColor: Colors.white,
                  )
                else
                  Text(
                    locationMessage,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
