import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SoftwareDetailsScreen extends StatelessWidget {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Software Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: deviceInfo.androidInfo.then((info) => info.toMap()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              children: snapshot.data?.entries
                      .map((entry) => ListTile(
                            title: Text(entry.key),
                            subtitle: Text(entry.value.toString()),
                          ))
                      .toList() ??
                  [],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
