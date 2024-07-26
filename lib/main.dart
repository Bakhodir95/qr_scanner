import 'package:flutter/material.dart';
import 'package:qr_scanner/views/screens/splash_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

@override
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
