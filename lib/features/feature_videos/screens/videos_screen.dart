import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:agrichapp/features/feature_videos/widgets/video_display.dart';
import 'package:agrichapp/features/feature_videos/widgets/video_skeleton.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:agrichapp/features/feature_authentication/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';

import '../models/thumbnail.dart';

class VideoScreen extends StatefulWidget {
  final String title;

  const VideoScreen({super.key, required this.title});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  List<Thumbnail> videos = [];
  late AuthProvider authProvider;
  late StorageMethods _storageMethods;

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    _storageMethods = StorageMethods(FirebaseStorage.instance);
    _storageMethods
        .getVideoListFromFolder(widget.title, videos)
        .then((value) {
      setState(() {
        videos = value;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        decoration: context.background,
        child: SafeArea(
          child: videos.isNotEmpty
              ? ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                  Thumbnail video = videos[index];
                  return VideoDisplay(thumbnail: video, saveVideo: (){
                    authProvider.saveViewedVideos(video: video);
                  },);
                })
              : ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return const VideoShimmerSkeleton();
                  },
                ),
        ),
      ),
    );
  }
}
