import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(DeviceCheckerApp());
}

class DeviceCheckerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Device Checker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
