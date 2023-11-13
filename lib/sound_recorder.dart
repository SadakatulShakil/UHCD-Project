import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

final pathToSaveAudio = DateTime.now().toString()+'_'+'example_audio.aac';
class SoundRecorder{

  bool isRecorderInitialised = false;
  bool get isRecording => _audioRecorder!.isRecording;
  FlutterSoundRecorder? _audioRecorder;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException('Microphone permission need to access Audio !');
    }
    await _audioRecorder!.openRecorder();
    isRecorderInitialised = true;
  }

  void dispose() {
    if(!isRecorderInitialised) return;
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    isRecorderInitialised = false;
  }

  Future _record() async {
    if(!isRecorderInitialised) return;
    await _audioRecorder!.startRecorder(toFile: pathToSaveAudio);
  }
  Future _stop() async {
    if(!isRecorderInitialised) return;
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
   if(_audioRecorder!.isStopped){
     await _record();
   }else{
     await _stop();
   }
  }

}