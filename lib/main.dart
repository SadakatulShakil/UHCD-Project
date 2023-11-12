import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> imagePaths = [];
  List<String> videoPaths = [];
  List<String> audioPaths = [];

  final ImagePicker _imagePicker = ImagePicker();
  final VideoPlayerController _videoController = VideoPlayerController.network(
      'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4');
  final AudioPlayer _audioPlayer = AudioPlayer();

  late CameraController _cameraController;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePaths.add(pickedFile.path);
      });
    }
  }

  Future<void> _recordVideo() async {
    final String videoPath = '/path/to/save/video_${DateTime.now().millisecondsSinceEpoch}.mp4';

    await _cameraController.startVideoRecording();

    // Add a button to stop recording
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Recording Video'),
        content: Text('Recording in progress...'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _cameraController.stopVideoRecording();
              setState(() {
                videoPaths.add(videoPath);
              });
              Navigator.pop(context);
            },
            child: Text('Stop Recording'),
          ),
        ],
      ),
    );
  }


  Future<void> _pickVideo() async {
    final pickedFile = await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        videoPaths.add(pickedFile.path);
      });
    }
  }

  Future<void> _recordAudio() async {
    final String audioPath = '/path/to/save/audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
    //await _audioPlayer.startRecord(path: audioPath, codec: Codec.mp3);

    // Add a button to stop recording
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Recording Audio'),
        content: Text('Recording in progress...'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              //await _audioPlayer.stopRecord();
              setState(() {
                audioPaths.add(audioPath);
              });
              Navigator.pop(context);
            },
            child: Text('Stop Recording'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAudio() async {
    final pickedFile = await _imagePicker.pickMedia();
    if (pickedFile != null) {
      setState(() {
        audioPaths.add(pickedFile.path);
      });
    }
  }

  Widget _buildMediaListView(List<String> paths) {
    return ListView.builder(
      itemCount: paths.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(paths[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Upload'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick Images'),
          ),
          Expanded(
            child: _buildMediaListView(imagePaths),
          ),
          ElevatedButton(
            onPressed: _recordVideo,
            child: Text('Record Video'),
          ),
          Expanded(
            child: _buildMediaListView(videoPaths),
          ),
          ElevatedButton(
            onPressed: _pickVideo,
            child: Text('Pick Videos'),
          ),
          Expanded(
            child: _buildMediaListView(audioPaths),
          ),
          ElevatedButton(
            onPressed: _recordAudio,
            child: Text('Record Audio'),
          ),
          Expanded(
            child: _buildMediaListView(audioPaths),
          ),
          ElevatedButton(
            onPressed: _pickAudio,
            child: Text('Pick Audio'),
          ),
        ],
      ),
    );
  }
}
