import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_scanner/controllers/qr_code_controller.dart';
import 'package:qr_scanner/views/screens/splash_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

@override
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QrCodeController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
