import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:ui';
import 'dart:async';

class BatteryTestScreen extends StatefulWidget {
  @override
  State<BatteryTestScreen> createState() => _BatteryTestScreenState();
}

class _BatteryTestScreenState extends State<BatteryTestScreen> {
  final Battery _battery = Battery();
  BatteryState _batteryState = BatteryState.unknown;
  int _batteryLevel = 0;
  late Timer _timer;
  String _batteryHealth = 'Checking...';
  String _chargingStatus = 'Unknown';
  String _temperature = 'N/A';

  @override
  void initState() {
    super.initState();
    _initBatteryInfo();
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      _updateBatteryInfo();
    });
  }

  Future<void> _initBatteryInfo() async {
    await _updateBatteryInfo();
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
        _updateChargingStatus();
      });
    });
  }

  Future<void> _updateBatteryInfo() async {
    final batteryLevel = await _battery.batteryLevel;
    final batteryState = await _battery.batteryState;
    
    setState(() {
      _batteryLevel = batteryLevel;
      _batteryState = batteryState;
      _updateBatteryHealth();
      _updateChargingStatus();
    });
  }

  void _updateBatteryHealth() {
    if (_batteryLevel >= 80) {
      _batteryHealth = 'Excellent';
    } else if (_batteryLevel >= 60) {
      _batteryHealth = 'Good';
    } else if (_batteryLevel >= 40) {
      _batteryHealth = 'Fair';
    } else {
      _batteryHealth = 'Poor';
    }
  }

  void _updateChargingStatus() {
    switch (_batteryState) {
      case BatteryState.charging:
        _chargingStatus = 'Charging';
        break;
      case BatteryState.discharging:
        _chargingStatus = 'Not charging';
        break;
      case BatteryState.full:
        _chargingStatus = 'Fully charged';
        break;
      default:
        _chargingStatus = 'Unknown';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildGlassCard(String title, String value, IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20),
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
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.red.shade300,
                size: 40,
              ),
              SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Battery Information',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
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
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      children: [
                        _buildGlassCard(
                          'Battery Level',
                          '$_batteryLevel%',
                          Icons.battery_full,
                        ),
                        _buildGlassCard(
                          'Battery Health',
                          _batteryHealth,
                          Icons.health_and_safety,
                        ),
                        _buildGlassCard(
                          'Charging Status',
                          _chargingStatus,
                          Icons.power,
                        ),
                        _buildGlassCard(
                          'Power Source',
                          _batteryState == BatteryState.charging ? 'AC Power' : 'Battery',
                          Icons.electrical_services,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}