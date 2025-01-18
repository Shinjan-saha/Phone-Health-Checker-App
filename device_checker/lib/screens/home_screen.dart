import 'package:flutter/material.dart';
import 'dart:ui';

import 'microphone_test.dart';
import 'camera_test.dart';
import 'battery_test.dart';
import 'software_details.dart';
import 'proccessor.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Device Checker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.shade900,
                  Colors.black,
                  Colors.black,
                ],
              ),
            ),
          ),
         
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView(
                children: [
                  SizedBox(height: 20),
                  _buildGlassCard(
                    context,
                    'Test Microphone & Speaker',
                    Icons.mic,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => MicrophoneTestScreen())),
                  ),
                  SizedBox(height: 15),
                  _buildGlassCard(
                    context,
                    'Test Camera',
                    Icons.camera_alt,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => CameraTestScreen())),
                  ),
                  SizedBox(height: 15),
                  _buildGlassCard(
                    context,
                    'Check Battery',
                    Icons.battery_charging_full,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => BatteryTestScreen())),
                  ),
                  SizedBox(height: 15),
                  _buildGlassCard(
                    context,
                    'Processor Data',
                    Icons.memory,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProcessorTestScreen())),
                  ),
                  SizedBox(height: 15),
                  _buildGlassCard(
                    context,
                    'Software Details',
                    Icons.info_outline,
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => SoftwareDetailsScreen())),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.red.shade300,
                      size: 30,
                    ),
                    SizedBox(width: 15),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.red.shade300,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}