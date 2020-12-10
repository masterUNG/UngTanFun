import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShowVideo extends StatefulWidget {
  @override
  _ShowVideoState createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    String dataSource =
        'http://edge4-bkk.3bb.co.th:1935/CartoonClub_Livestream/cartoonclub_480P.stream/playlist.m3u8';
    videoPlayerController = VideoPlayerController.network(dataSource)
      ..initialize().then((value) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          videoPlayerController.value.isPlaying
              ? videoPlayerController.pause()
              : videoPlayerController.play();
        });
      }),
      body: videoPlayerController.value.initialized
          ? AspectRatio(aspectRatio: videoPlayerController.value.aspectRatio)
          : Text('Cannot Open Video'),
    );
  }
}
