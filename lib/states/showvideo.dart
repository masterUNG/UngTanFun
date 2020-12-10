import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShowVideo extends StatefulWidget {
  @override
  _ShowVideoState createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    // String dataSource =
    //     'http://edge4-bkk.3bb.co.th:1935/CartoonClub_Livestream/cartoonclub_480P.stream/playlist.m3u8';
    // videoPlayerController = VideoPlayerController.network(dataSource)
    //   ..initialize().then((value) {
    //     setState(() {});
    //   });

    videoPlayerController = VideoPlayerController.network(
        'http://edge4-bkk.3bb.co.th:1935/CartoonClub_Livestream/cartoonclub_480P.stream/playlist.m3u8');
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
    );
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
      body: Chewie(
        controller: chewieController,
      ),
    );
    //   body: videoPlayerController.value.initialized
    //       ? AspectRatio(aspectRatio: videoPlayerController.value.aspectRatio)
    //       : Text('Cannot Open Video'),
    // );
  }
}
