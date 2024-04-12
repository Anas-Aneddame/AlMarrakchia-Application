import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_app/services/network_connectivity.dart';
import 'package:new_app/widgets/current_weather_new.dart';
import 'package:new_app/widgets/geo_location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  double _latitude = 0;
  double _longitude = 0;
  int _hasLocation = 2;

  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  int isOnline = 0;

  @override
  void initState() {
    super.initState();
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          if (_source.values.toList()[0]) {
            isOnline = 1;
          }

          break;
        case ConnectivityResult.wifi:
          if (_source.values.toList()[0]) {
            isOnline = 1;
          }
          break;
        case ConnectivityResult.none:
        default:
          isOnline = 0;

          
      }
      if (isOnline == 1) {
        getCoordinates();
      }
      else if(isOnline==0){
        getRetryScreen();
      }
    });
  }

  getCoordinates() {
    getPosition().then((position) {
      if(mounted)
      {
      if (position != null) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _hasLocation = 1;
        });
      } else {
        setState(() {
          _hasLocation = 0;
        });
      }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA80D14),
        elevation: 0.0,
        title: const Text(
          "احوال الطقس",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
      ),
      body: getWeatherView(),
    );
  }

  refresh() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WeatherPage()),
    );
  }

  Widget getWeatherView() {
    if (isOnline == 1) {

      if (_hasLocation == 1) {
        return CurrentWeather(_latitude, _longitude);
      } else if (_hasLocation == 0) {
        return RefreshIndicator(
          onRefresh: () async {
            return getCoordinates();
          },
          child: Center(
            child: ListView(children: [
              SizedBox(
                height:MediaQuery.of(context).size.height*0.8,
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      const Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          "المرجو التحقق من تفعيل الموقع أو إذن استخدامه",
                          style: TextStyle(
                            // color:Colors.grey,
                            fontSize: 18,
                            color: Color(0xFFa80d14),
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => openAppSettings(),
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(
                            // Customize the text style of the button
                            fontSize: 20,
                            color: Color(0xFFa80d14),
                          )),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(
                                0xFFa80d14), // Set the text color to white
              
                            // Customize the background color of the button
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(5.0, 2, 5, 2),
                          child: Text('إفتح الإعدادات'),
                        ),
                      ),
                    ])),
              ),
            ]),
          ),
        );
      }
      return const Center(
          child: SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(),
      ));
    } else if (isOnline == 0) {
      return getRetryScreen();
    }

    return const Center(
        child: SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    ));
  }

  SizedBox getRetryScreen() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                "ليس هناك اتصال",
                style: TextStyle(
                  // color:Colors.grey,
                  fontSize: 20,
                  color: Color(0xFFa80d14),
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WeatherPage()),
                )
              },
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(
                  // Customize the text style of the button
                  fontSize: 20,
                  color: Color(0xFFa80d14),
                )),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFFa80d14), // Set the text color to white

                  // Customize the background color of the button
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(5.0, 2, 5, 2),
                child: Text("أعد المحاولة"),
              ),
            )
          ],
        ));
  }
}
