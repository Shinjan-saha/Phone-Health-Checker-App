import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ProcessorTestScreen extends StatefulWidget {
  @override
  _ProcessorTestScreenState createState() => _ProcessorTestScreenState();
}

class _ProcessorTestScreenState extends State<ProcessorTestScreen> {
  static const platform = MethodChannel('com.example.cpu_info');
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> _processorInfo = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDeviceInfo();
  }

  Future<void> _fetchDeviceInfo() async {
    setState(() => _isLoading = true);
    
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _processorInfo = {
            'Model': androidInfo.model,
            'Manufacturer': androidInfo.manufacturer,
            'Hardware': androidInfo.hardware,
            'Board': androidInfo.board,
            'Device': androidInfo.device,
            'Product': androidInfo.product,
            'CPU Cores': androidInfo.supportedAbis.length.toString(),
            'Architecture': androidInfo.supportedAbis.first,
            'Android Version': androidInfo.version.release,
            'SDK Version': androidInfo.version.sdkInt.toString(),
            'Security Patch': androidInfo.version.securityPatch ?? 'Unknown',
          };
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _processorInfo = {
            'Model': iosInfo.model,
            'Name': iosInfo.name,
            'System Name': iosInfo.systemName,
            'System Version': iosInfo.systemVersion,
            'Processor Cores': iosInfo.utsname.machine,
            'Physical Device': iosInfo.isPhysicalDevice ? 'Yes' : 'No',
            'Memory': '${(iosInfo.utsname.version.length / 1024).toStringAsFixed(2)} GB',
          };
        });
      }
    } catch (e) {
      setState(() {
        _processorInfo = {'Error': 'Failed to fetch device information'};
      });
    }
    
    setState(() => _isLoading = false);
  }

  Widget _buildInfoCard(String title, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(15),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
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
                onTap: onPressed,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.red.shade300,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
          'Processor Information',
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
          // Background gradient
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
          // Content
          SafeArea(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.red.shade300,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(20),
                          children: [
                            ..._processorInfo.entries.map(
                              (entry) => Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: _buildInfoCard(
                                  entry.key,
                                  entry.value.toString(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: _buildGlassButton(
                          onPressed: _fetchDeviceInfo,
                          text: 'Refresh Information',
                          icon: Icons.refresh,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}