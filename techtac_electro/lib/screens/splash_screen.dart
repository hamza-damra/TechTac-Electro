import 'dart:async';
import 'package:flutter/material.dart';
import 'package:techtac_electro/screens/root_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const RootScreen(),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 2),
          child: Image.asset('assets/images/splash_screen.png'),
        ),
      ),
    );
  }
}
