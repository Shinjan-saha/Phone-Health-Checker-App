import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui';

class MicrophoneTestScreen extends StatefulWidget {
  @override
  _MicrophoneTestScreenState createState() => _MicrophoneTestScreenState();
}

class _MicrophoneTestScreenState extends State<MicrophoneTestScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  String _filePath = 'audio_test.aac';

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    await Permission.microphone.request();
    if (await Permission.microphone.isGranted) {
      await _recorder.openRecorder();
      await _player.openPlayer();
    } else {
      throw RecordingPermissionException('Microphone permission not granted');
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _isRecording = true;
    });
    await _recorder.startRecorder(
      toFile: _filePath,
    );
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playRecording() async {
    if (_filePath.isNotEmpty) {
      await _player.startPlayer(
        fromURI: _filePath,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No recording found to play.')),
      );
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
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
          'Microphone Test',
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Microphone Icon
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: _isRecording ? Colors.red.shade300 : Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 50,
                      color: _isRecording ? Colors.red.shade300 : Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildGlassButton(
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                    text: _isRecording ? 'Stop Recording' : 'Start Recording',
                    icon: _isRecording ? Icons.stop : Icons.fiber_manual_record,
                  ),
                  _buildGlassButton(
                    onPressed: _playRecording,
                    text: 'Play Recording',
                    icon: Icons.play_arrow,
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