import 'dart:async';

import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const  Directionality(
                    textDirection: TextDirection.rtl, child: Home()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: const Center(
              child: Text("المراكشية",
                  style: TextStyle(
                      color: Color(0xFFa80d14),
                      fontSize: 66,
                      fontWeight: FontWeight.w100,
                      letterSpacing: 1.5
                      // fontFamily: 'Cairo'
                  )))),
    );
  }
}
