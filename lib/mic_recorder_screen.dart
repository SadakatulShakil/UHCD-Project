import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FlutterSoundRecorder _flutterSoundRecorder;
  late FlutterSoundPlayer _flutterSoundPlayer;
  late Directory directory;
  bool isRecording = false;
  List<String> audioFiles = [];

  @override
  void initState() {
    super.initState();
    _flutterSoundRecorder = FlutterSoundRecorder();
    _flutterSoundPlayer = FlutterSoundPlayer();
    _initializeRecorder();
    _loadAudioFiles();
  }

  // Add this method to handle recorder initialization
  _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException('Microphone permission need to access Audio !');
    }
    try {
      await _flutterSoundRecorder.openRecorder();
    } catch (e) {
      print('Error initializing recorder: $e');
    }
  }

  _loadAudioFiles() async {
    Directory directory = Directory('/storage/emulated/0/Music/Recordings/custom'); // Replace with your actual path
    List<FileSystemEntity> files = directory.listSync();
    setState(() {
      audioFiles = files
          .where((file) => file.path.endsWith('.wav'))
          .map((file) => file.path)
          .toList();
    });
  }

  _startRecording() async {
    String last_path = DateTime.now().toString();
    String last_path_ex = last_path.replaceAll('-', '')
        .replaceAll(':', '').replaceAll('.', '').replaceAll(' ', '')+'.wav';
    print('path: '+last_path_ex);
    await _flutterSoundRecorder.startRecorder(
      toFile: '/storage/emulated/0/Music/Recordings/custom/$last_path_ex',
    );
    setState(() {
      isRecording = true;
    });
  }

  _stopRecording() async {
    if (isRecording) {
      await _flutterSoundRecorder.stopRecorder();
      setState(() {
        isRecording = false;
      });
      _loadAudioFiles(); // Reload the list of audio files after recording
    }
  }


  _playAudio(String filePath) async {
    await _flutterSoundPlayer.startPlayer(
      fromURI: filePath,
      codec: Codec.pcm16WAV,
    );
  }

  _showFileDetails(String filePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Audio File Details'),
          content: Text('File Path: $filePath'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _flutterSoundRecorder.closeRecorder();
    _flutterSoundPlayer.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Recorder'),
      ),
      body: Column(
        children: [
          if (isRecording)
            Text('Recording...'),
          ElevatedButton(
            onPressed: isRecording ? _stopRecording : _startRecording,
            child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
          ),
          ElevatedButton(
            onPressed: () {
              // Show list of audio files
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Audio Files'),
                    content: Container(
                      width: double.minPositive,
                      child: ListView.builder(
                        itemCount: audioFiles.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(audioFiles[index]),
                            onTap: () {
                              _showFileDetails(audioFiles[index]);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            child: Text('Show Files'),
          ),
        ],
      ),
    );
  }
}
