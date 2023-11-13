// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:camera/camera.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<File> imageFiles = [];
//   List<File> videoFiles = [];
//   List<File> audioFiles = [];
//
//   final ImagePicker _imagePicker = ImagePicker();
//   final VideoPlayerController _videoController = VideoPlayerController.network(
//       'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4');
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   late CameraController _cameraController;
//   late List<CameraDescription> cameras;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     cameras = await availableCameras();
//     _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
//     await _cameraController.initialize();
//   }
//
//   @override
//   void dispose() {
//     _videoController.dispose();
//     _audioPlayer.dispose();
//     _cameraController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         imageFiles.add(File(pickedFile.path));
//       });
//     }
//   }
//
//   Future<void> _recordVideo() async {
//     final String videoPath = '/path/to/save/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
//
//     await _cameraController.startVideoRecording();
//
//     // Add a button to stop recording
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Recording Video'),
//         content: Text('Recording in progress...'),
//         actions: [
//           ElevatedButton(
//             onPressed: () async {
//               await _cameraController.stopVideoRecording();
//               setState(() {
//                 videoFiles.add(File(videoPath));
//               });
//               Navigator.pop(context);
//             },
//             child: Text('Stop Recording'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _pickVideo() async {
//     final pickedFile = await _imagePicker.pickVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         videoFiles.add(File(pickedFile.path));
//       });
//     }
//   }
//
//   Future<void> _recordAudio() async {
//     final String audioPath = '/path/to/save/audio_${DateTime.now().millisecondsSinceEpoch}.mp3';
//
//     //await _audioPlayer.startRecord(path: audioPath, codec: Codec.mp3);
//
//     // Add a button to stop recording
//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Recording Audio'),
//         content: Text('Recording in progress...'),
//         actions: [
//           ElevatedButton(
//             onPressed: () async {
//               await _audioPlayer.stop();
//               setState(() {
//                 audioFiles.add(File(audioPath));
//               });
//               Navigator.pop(context);
//             },
//             child: Text('Stop Recording'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _pickAudio() async {
//     final pickedFile = await _imagePicker.pickMedia();
//     if (pickedFile != null) {
//       setState(() {
//         audioFiles.add(File(pickedFile.path));
//       });
//     }
//   }
//
//   Widget _buildMediaList(List<File> files, Function(int) onDelete) {
//     return ListView.builder(
//       itemCount: files.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: IconButton(
//             icon: Icon(Icons.cancel),
//             onPressed: () => onDelete(index),
//           ),
//           title: _buildPreviewWidget(files[index]),
//         );
//       },
//     );
//   }
//
//   Widget _buildPreviewWidget(File file) {
//     if (imageFiles.contains(file)) {
//       return Image.file(file);
//     } else if (videoFiles.contains(file)) {
//       return VideoPlayer(_videoController);
//     } else if (audioFiles.contains(file)) {
//       return Text('Audio Player for ${file.path}');
//     } else {
//       return Text('Unknown file type');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Media Upload'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _pickImage,
//             child: Text('Pick Images'),
//           ),
//           Expanded(
//             child: _buildMediaList(imageFiles, (index) {
//               setState(() {
//                 imageFiles.removeAt(index);
//               });
//             }),
//           ),
//           ElevatedButton(
//             onPressed: _recordVideo,
//             child: Text('Record Video'),
//           ),
//           Expanded(
//             child: _buildMediaList(videoFiles, (index) {
//               setState(() {
//                 videoFiles.removeAt(index);
//               });
//             }),
//           ),
//           ElevatedButton(
//             onPressed: _pickVideo,
//             child: Text('Pick Videos'),
//           ),
//           Expanded(
//             child: _buildMediaList(audioFiles, (index) {
//               setState(() {
//                 audioFiles.removeAt(index);
//               });
//             }),
//           ),
//           ElevatedButton(
//             onPressed: _recordAudio,
//             child: Text('Record Audio'),
//           ),
//           Expanded(
//             child: _buildMediaList(audioFiles, (index) {
//               setState(() {
//                 audioFiles.removeAt(index);
//               });
//             }),
//           ),
//           ElevatedButton(
//             onPressed: _pickAudio,
//             child: Text('Pick Audio'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';
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

  getMultipleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      List<File> newFiles = result.paths.map((path) => File(path!)).toList() ?? [];
      _imageList.addAll(newFiles);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select at least 1 file'),
      ));
    }
  }

  getMultipleFile1() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      // You want to pass different argument
      // in these 2 property in above function
    );

    if (result != null) {
      List<File> newFiles = result.paths.map((path) => File(path!)).toList() ?? [];
     _videoList.addAll(newFiles);
      setState(() {});
    } else {
      // You can show snackbar or fluttertoast here like this to show warning to user
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select atleast 1 file'),
      ));
    }
  }
  getMultipleFile2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
      // You want to pass different argument
      // in these 2 property in above function
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
                    getMultipleFile();
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
                    getMultipleFile1();
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
                            future: VideoThumbnail.thumbnailData(
                              video: _videoList[index]!.path,
                              imageFormat: ImageFormat.PNG,
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
                    getMultipleFile2();
                  },
                  child: Text('Choose Audio'),
                ),
              ),
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
