import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uhcd_childreen_project/sound_recorder.dart';

class RecorderScreen extends StatefulWidget{
  const RecorderScreen({super.key});

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();

}

class _RecorderScreenState extends State<RecorderScreen>{

  bool visibleBool = false;
  final recorder = SoundRecorder();
  late Timer _timer;
  int _seconds = 0;
  Widget buildStart(){
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'STOP' : 'START';
    final backgroundColor = isRecording ? Colors.red:Colors.white;
    final foregroundColor = isRecording ? Colors.white:Colors.black;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(minimumSize: Size(175, 50),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor
      ),
        onPressed: ()async{
        final _isRecording = await recorder.toggleRecording();
        setState(() {
          visibleBool = isRecording;
          isRecording?_stopTimer():_startTimer();
          print('kkkkkk: '+ _isRecording.toString());
        });
        },
        icon: Icon(icon),
        label: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
    );
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
  }

  void _restartTimer() {
    _stopTimer();
    setState(() {
      _seconds = 0;
    });
    _startTimer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recorder.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    recorder.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
    backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 90,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic),
                    Text(
                      '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    Text('Press START')
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                  visible: visibleBool?true:false,
                  child: GestureDetector(
                    onTap: (){
                      _restartTimer();
                    },
                      child: Icon(Icons.delete_sweep, color: Colors.white,)),
                ),
                buildStart(),
                Visibility(
                  visible: visibleBool?true:false,
                  child: GestureDetector(
                    onTap: (){
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Need to implement file path and send to audio list'),
                      ));
                    },
                      child: Icon(Icons.save_as_sharp, color: Colors.white,)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
