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
