import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';
import 'package:video_player/video_player.dart';

import 'GradientFab.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget(this.videoUrl);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState(videoUrl);
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  final VideoPlayerController videoPlayerController;
  final String videoUrl;
  double videoDuration = 0;
  double currentDuration = 0;
  _VideoPlayerWidgetState(this.videoUrl)
      : videoPlayerController = VideoPlayerController.network(videoUrl);

  @override
  void initState() {
    super.initState();
    videoPlayerController.initialize().then((_) {
      setState(() {
        videoDuration =
            videoPlayerController.value.duration.inMilliseconds.toDouble();
      });

    });

    videoPlayerController.addListener(() {
      setState(() {
        currentDuration = videoPlayerController.value.position.inMilliseconds.toDouble();
      });
    });
    print(videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      // This line set the transparent background
      child: Container(
          color: Palette.primaryBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: Palette.secondaryColor,
                constraints: BoxConstraints(maxHeight: 400),
                child: videoPlayerController.value.initialized
                    ? AspectRatio(
                        aspectRatio: videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(videoPlayerController),
                      )
                    : Container(
                        height: 200,
                        color: Palette.secondaryColor,
                      ),
              ),
              Slider(
                value: currentDuration,
                max: videoDuration,
                onChanged: (value) => videoPlayerController
                    .seekTo(Duration(milliseconds: value.toInt())),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:24.0),
                child: GradientFab(
                    elevation: 0,
                    child: Icon(
                      videoPlayerController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        videoPlayerController.value.isPlaying
                            ? videoPlayerController.pause()
                            : videoPlayerController.play();
                      });
                    }),
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}
