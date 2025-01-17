import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryTestScreen extends StatefulWidget {
  @override
  State<BatteryTestScreen> createState() => _BatteryTestScreenState();
}

class _BatteryTestScreenState extends State<BatteryTestScreen> {
  final Battery battery = Battery();
  int batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    battery.batteryLevel.then((level) => setState(() => batteryLevel = level));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Battery Test')),
      body: Center(
        child: Text('Battery Level: $batteryLevel%'),
      ),
    );
  }
}
