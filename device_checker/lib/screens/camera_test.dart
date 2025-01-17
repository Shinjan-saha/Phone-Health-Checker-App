import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class CameraTestScreen extends StatefulWidget {
  @override
  _CameraTestScreenState createState() => _CameraTestScreenState();
}

class _CameraTestScreenState extends State<CameraTestScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _capturedImagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController =
          CameraController(_cameras!.first, ResolutionPreset.high);
      await _cameraController?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final image = await _cameraController!.takePicture();
      setState(() {
        _capturedImagePath = image.path;
      });
      _showCapturedImage();
    } catch (e) {
      debugPrint('Error capturing picture: $e');
    }
  }

  void _showCapturedImage() {
    if (_capturedImagePath != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CapturedImageScreen(imagePath: _capturedImagePath!),
        ),
      );
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Test')),
      body: _isCameraInitialized
          ? Column(
              children: [
                Expanded(
                  flex: 3,
                  child: CameraPreview(_cameraController!),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _takePicture,
                  child: const Text('Capture Image'),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class CapturedImageScreen extends StatelessWidget {
  final String imagePath;

  const CapturedImageScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Captured Image')),
      body: Center(
        child: imagePath.isNotEmpty
            ? Image.file(File(imagePath))
            : const Text('No image captured'),
      ),
    );
  }
}
