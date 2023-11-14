import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uhcd_childreen_project/recorder_screen.dart';
import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart'as thumb;

import 'mic_recorder_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultipleFilepickerScreen(),
    );
  }
}

class MultipleFilepickerScreen extends StatefulWidget {
  const MultipleFilepickerScreen({super.key});

  @override
  State<MultipleFilepickerScreen> createState() =>
      _MultipleFilepickerScreenState();
}

class _MultipleFilepickerScreenState extends State<MultipleFilepickerScreen> {
  List<File?> _imageList = [];
  List<File?> _videoList = [];
  List<File?> _audioList = [];
  late Timer _timer;
  int _seconds = 0;
  String _currentRecordingFolder = '';
  late FlutterSoundRecorder _flutterSoundRecorder;
  late FlutterSoundPlayer _flutterSoundPlayer;
  late Directory directory;
  bool isRecording = false;
  void getFiles(ImageSource imageSource, String usedFor) async {
    if(usedFor == 'image'){
      XFile? file = await ImagePicker()
          .pickImage(source: imageSource, imageQuality: 10);
      if (file != null) {
        // Convert XFile to File
        File newFile = File(file.path);

        // Add the captured image to the list
        _imageList.add(newFile);

        // Update the UI
        setState(() {});
      }
    }
    else if(usedFor == 'video'){
      XFile? file = await ImagePicker()
          .pickVideo(source: imageSource,);
      if (file != null) {
        // Convert XFile to File
        File newFile = File(file.path);

        // Add the captured image to the list
        _videoList.add(newFile);

        // Update the UI
        setState(() {});
      }
    }
    else{
      if(imageSource == ImageSource.gallery){
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.audio,
        );

        if (result != null) {
          List<File> newFiles = result.paths.map((path) => File(path!)).toList() ?? [];
          _audioList.addAll(newFiles);
          setState(() {});
        } else {
          // You can show snackbar or fluttertoast here like this to show warning to user
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please select atleast 1 file'),
          ));
        }
      }
    }
  }

  _startRecording() async {
    String timestamp = DateTime.now().toString();
    String _currentRecordingFolder = '$timestamp'.replaceAll('-', '').replaceAll(':', '').replaceAll('.', '').replaceAll(' ', '');

    await _flutterSoundRecorder.startRecorder(
      toFile: '/storage/emulated/0/Music/Recordings/custom/$_currentRecordingFolder.wav',
    );

    setState(() {
      _startTimer();
      isRecording = true;
    });
  }

  _loadAudioFiles() async {
    Directory directory = Directory('/storage/emulated/0/Music/Recordings/custom');

    // Ensure the directory exists, and create it if not
    if (!(await directory.exists())) {
      await directory.create(recursive: true);
    }

    List<FileSystemEntity> files = directory.listSync();
    // Sort files based on last modified time in descending order
    files.sort((a, b) => (b.statSync().modified.compareTo(a.statSync().modified)));

    // Load only the latest file, if any
    if (files.isNotEmpty) {
      setState(() {
        _audioList = [..._audioList, File(files.first.path)];
      });
    } else {
      // No files found
      setState(() {
        //_audioList = [];
      });
    }
  }

  _stopRecording() async {
    if (isRecording) {
      await _flutterSoundRecorder.stopRecorder();
      setState(() {
        _stopTimer();
        isRecording = false;
      });
      _loadAudioFiles(); // Reload the list of audio files after recording
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    setState(() {
      _seconds = 0;
    });
  }
  //
  // void _restartTimer() {
  //   _stopTimer();
  //   setState(() {
  //     _seconds = 0;
  //   });
  //   _startTimer();
  // }

  Future<void> showFileDialog(String title, String usedFor) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  getFiles(ImageSource.camera, usedFor);
                  setState(() {});
                },
                child: usedFor == 'audio'?Text('Recorder'):Text('Camera'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  getFiles(ImageSource.gallery, usedFor);
                  setState(() {});
                },
                child: Text('Gallery'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _flutterSoundRecorder = FlutterSoundRecorder();
    _flutterSoundPlayer = FlutterSoundPlayer();
    _initializeRecorder();
    //_loadAudioFiles();
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



  @override
  void dispose() {
    _flutterSoundRecorder.closeRecorder();
    _flutterSoundPlayer.closePlayer();
    super.dispose();
  }
// Variable for showing multiple file
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: OutlinedButton(
                  onPressed: () async {
                    showFileDialog('Get Image From', 'image');
                    //getMultipleFile();
                  },
                  child: Text('Choose Image'),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemCount: _imageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 20,
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: <Widget>[
                            Image.file(
                              File(_imageList[index]!.path),
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: InkWell(
                                child: Icon(
                                  Icons.remove_circle,
                                  size: 25,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  setState(() {
                                    _imageList.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: OutlinedButton(
                  onPressed: () async {
                    //getMultipleFile1();
                    showFileDialog('Get Video from', 'video');
                  },
                  child: Text('Choose Video'),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: _videoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 20,
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: <Widget>[
                          FutureBuilder(
                            future: thumb.VideoThumbnail.thumbnailData(
                              video: _videoList[index]!.path,
                              imageFormat: thumb.ImageFormat.PNG,
                              quality: 30,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Image.memory(
                                  snapshot.data as Uint8List,
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: InkWell(
                              child: Icon(
                                Icons.remove_circle,
                                size: 25,
                                color: Colors.red,
                              ),
                              onTap: () {
                                setState(() {
                                  _videoList.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: OutlinedButton(
                  onPressed: () async {
                    //getMultipleFile2();
                    showFileDialog('Get Audio from', 'audio');
                  },
                  child: Text('Audio section :'),
                ),
              ),
            ),
            if (isRecording)  Padding(
              padding: const EdgeInsets.only(left: 45.0),
              child: Row(
                children: [
                  Text('🔊'),
                  SizedBox(width: 5,),
                  Text(
                    '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               ElevatedButton(
                 style: ElevatedButton.styleFrom(backgroundColor: isRecording?Colors.red:Colors.blue),
                 onPressed: isRecording ? _stopRecording : _startRecording,
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Icon(isRecording ? Icons.stop : Icons.mic),
                     SizedBox(width: 8.0), // Adjust the spacing as needed
                     Text(isRecording ? 'STOP' : 'START'),
                   ],
                 )
               ),
               Text('or'),
               ElevatedButton(
                 onPressed: (){
                   getFiles(ImageSource.gallery, 'audio');
                 },
                 child: Text('Choose file'),
               ),
             ],
           ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemCount: _audioList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 20,
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: <Widget>[
                            Image.asset('assets/images/mp3.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: InkWell(
                                child: Icon(
                                  Icons.remove_circle,
                                  size: 25,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  setState(() {
                                    _audioList.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),

          ],
        ),
      ),
    );
  }
}
