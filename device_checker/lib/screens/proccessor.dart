import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // For platform channels
import 'dart:io';

class ProcessorTestScreen extends StatefulWidget {
  @override
  _ProcessorTestScreenState createState() => _ProcessorTestScreenState();
}

class _ProcessorTestScreenState extends State<ProcessorTestScreen> {
  static const platform = MethodChannel('com.example.cpu_info'); // Define your method channel
  String _processorDetails = "Fetching processor details...";

  @override
  void initState() {
    super.initState();
    _fetchCpuInfo();
  }

  // Fetch CPU info using platform channel
  Future<void> _fetchCpuInfo() async {
    try {
      final String cpuInfo = await platform.invokeMethod('getCpuInfo');
      setState(() {
        _processorDetails = cpuInfo;
      });
    } on PlatformException catch (e) {
      setState(() {
        _processorDetails = "Failed to get CPU info: '${e.message}'.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Processor Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Processor Information:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(_processorDetails),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchCpuInfo,
              child: Text("Refresh Processor Details"),
            ),
          ],
        ),
      ),
    );
  }
}
