import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import '../models/video_info.dart';

class VideoPlayer extends StatefulWidget {
  final String name;
  final String category;

  const VideoPlayer({super.key, required this.name, required this.category});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late Video video;

  @override
  void initState() {
    // TODO: implement initState
    // storageMethods.getVideoFromFolder(widget.category, widget.name);
    video = Video(name: widget.name, path: widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: FutureBuilder(
            future: video.init(),
            builder: (builder, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              }
              return BetterPlayer(
                controller: video.betterPlayerController,
              );
            }),
      ),
    );
  }
}
