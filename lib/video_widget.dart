import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({required this.videoPath, Key? key}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  void _initializePlayer() {
    VideoPlayerController videoPlayerController = VideoPlayerController.file(File(widget.videoPath));
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: false,
      showControls: true,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }
}
