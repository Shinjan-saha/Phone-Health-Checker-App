import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:ui';
import 'dart:io';

class SoftwareDetailsScreen extends StatefulWidget {
  @override
  _SoftwareDetailsScreenState createState() => _SoftwareDetailsScreenState();
}

class _SoftwareDetailsScreenState extends State<SoftwareDetailsScreen> {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  Map<String, String> _softwareInfo = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSoftwareInfo();
  }

  Future<void> _fetchSoftwareInfo() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await deviceInfo.androidInfo;
        setState(() {
          _softwareInfo = {
            'Android Version': info.version.release,
            'SDK Version': info.version.sdkInt.toString(),
            'Security Patch': info.version.securityPatch ?? 'Unknown',
            'Board': info.board,
            'Brand': info.brand,
            'Device': info.device,
            'Display': info.display,
            'Fingerprint': info.fingerprint,
            'Host': info.host,
            'ID': info.id,
            'Manufacturer': info.manufacturer,
            'Model': info.model,
            'Product': info.product,
            'Type': info.type,
          };
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await deviceInfo.iosInfo;
        setState(() {
          _softwareInfo = {
            'System Name': info.systemName,
            'System Version': info.systemVersion,
            'Model': info.model,
            'Localized Model': info.localizedModel,
            'Name': info.name,
            'Identifier': info.identifierForVendor ?? 'Unknown',
          };
        });
      }
    } catch (e) {
      setState(() {
        _softwareInfo = {'Error': 'Failed to fetch software information'};
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  fontSize: 14,
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
          'Software Details',
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
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.red.shade300,
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      ..._softwareInfo.entries.map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: _buildInfoCard(
                            entry.key,
                            entry.value,
                          ),
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