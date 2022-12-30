import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_viewer/video_viewer.dart' as video;

class VideoViewer extends StatelessWidget {
  VideoViewer({super.key, required this.file});

  File file;
  final video.VideoViewerController controller = video.VideoViewerController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: video.VideoViewer(
        controller: controller,
        source: {
          // "Video": Video.VideoSource(
          //     video: Video.VideoPlayerController.network(
          //         "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")),
          "file":
              video.VideoSource(video: video.VideoPlayerController.file(file)),
        },
        autoPlay: true,
      ),
    );
  }
}
