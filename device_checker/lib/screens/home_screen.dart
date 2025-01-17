import 'package:flutter/material.dart';

import 'microphone_test.dart';
import 'camera_test.dart';
import 'battery_test.dart';
import 'software_details.dart';
import 'proccessor.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device Checker')),
      body: ListView(
        children: [
          
          ListTile(
            title: Text('Test Microphone & Speaker'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => MicrophoneTestScreen())),
          ),
          ListTile(
            title: Text('Test Camera'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => CameraTestScreen())),
          ),
          ListTile(
            title: Text('Check Battery'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => BatteryTestScreen())),
          ),
           ListTile(
            title: Text('Test Proccessor'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => ProcessorTestScreen())),
          ),
          ListTile(
            title: Text('Software Details'),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => SoftwareDetailsScreen())),
          ),
        ],
      ),
    );
  }
}
