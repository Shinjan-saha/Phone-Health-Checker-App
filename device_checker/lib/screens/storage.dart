import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StorageInfoScreen extends StatefulWidget {
  @override
  _StorageInfoScreenState createState() => _StorageInfoScreenState();
}

class _StorageInfoScreenState extends State<StorageInfoScreen> {
  String _storageDetails = "Fetching storage details...";
  List<FileSystemEntity> _largeFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStorageInfo();
  }

  Future<void> _fetchStorageInfo() async {
    try {
     
      final dir = await getApplicationDocumentsDirectory();
      final totalSpace = await _getTotalSpace(dir);
      final freeSpace = await _getFreeSpace(dir);

    
      final largeFiles = await _findLargeFiles(dir, sizeLimit: 50 * 1024 * 1024);

      setState(() {
        _storageDetails = """
Total Space: ${_formatBytes(totalSpace)}
Free Space: ${_formatBytes(freeSpace)}
Files Found: ${largeFiles.length}
        """;
        _largeFiles = largeFiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _storageDetails = "Error fetching storage details: $e";
        _isLoading = false;
      });
    }
  }

  Future<int> _getTotalSpace(Directory dir) async {
    final stat = await dir.stat();
    return stat.size;
  }

  Future<int> _getFreeSpace(Directory dir) async {
    final freeSpace = await dir.stat();
    return freeSpace.size;
  }

  Future<List<FileSystemEntity>> _findLargeFiles(Directory dir,
      {int sizeLimit = 50 * 1024 * 1024}) async {
    final files = <FileSystemEntity>[];
    await for (FileSystemEntity entity
        in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        final stat = await entity.stat();
        if (stat.size > sizeLimit) {
          files.add(entity);
        }
      }
    }
    return files;
  }

  String _formatBytes(int bytes, [int decimals = 2]) {
    if (bytes == 0) return "0 B";
    const sizes = ["B", "KB", "MB", "GB", "TB"];
    final i = (bytes / 1024).floor();
    return "${(bytes / (1024 ^ i)).toStringAsFixed(decimals)} ${sizes[i]}";
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
          'Storage Information',
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
                      _buildInfoCard("Storage Details", _storageDetails),
                      if (_largeFiles.isNotEmpty)
                        ..._largeFiles.map((file) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: _buildInfoCard(
                              "Large File",
                              file.path.split('/').last,
                            ),
                          );
                        }),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}