import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:agrichapp/features/feature_authentication/services/firebase_auth_methods.dart';
import 'package:agrichapp/features/feature_tips/widgets/tip_shimmer.dart';
import 'package:agrichapp/features/feature_tips/models/card_info.dart';
import 'package:agrichapp/features/feature_videos/widgets/video_display.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../feature_videos/models/thumbnail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AuthProvider authProvider;
  late StorageMethods storageMethods;
  List<String> stringVideos = [];
  List<Thumbnail> viewedVideos = [];

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    super.initState();
    storageMethods = StorageMethods(FirebaseStorage.instance);
    authProvider.getViewedVideos().then((value) {
      setState(() {
        stringVideos = value;
      });
      for (String video in stringVideos) {
        Thumbnail vid = Thumbnail.fromString(data: video);
        if (kDebugMode) {
          print(vid);
        }
        viewedVideos.insert(0, vid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 30,
            bottom: 15,
            top: MediaQuery.paddingOf(context).top * 2,
          ),
          alignment: Alignment.topLeft,
          child: Text(
            'Tip for today',
            style: Theme.of(context).textTheme.titleLarge,
            textScaleFactor: 0.8,
          ),
        ),
        Container(
          height: MediaQuery.sizeOf(context).height * 0.23,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: FutureBuilder(
            future: authProvider.loadTip(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                CardInfo info = CardInfo(
                  tip: snapshot.data,
                  day: DateFormat.yMMMd().format(
                    DateTime.now(),
                  ),
                );
                authProvider.saveTip(info: info);

                return AnimatedTextKit(
                  displayFullTextOnTap: true,
                  isRepeatingAnimation: false,
                  totalRepeatCount: 1,
                  animatedTexts: [
                    TyperAnimatedText(
                      snapshot.data,
                      textStyle: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }
              return const TipShimmerSkeleton();
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 30, bottom: 5),
          alignment: Alignment.topLeft,
          child: Text(
            'Previous Videos',
            style: Theme.of(context).textTheme.titleMedium,
            textScaleFactor: 0.8,
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.48,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          alignment: Alignment.center,
          child: viewedVideos.isEmpty
              ?
              // child:
              Text(
                  'No Viewed Videos',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey),
                  textScaleFactor: 0.65,
                )
              : ListView.builder(
                  itemCount: viewedVideos.length,
                  itemBuilder: (context, index) {
                    Thumbnail video = viewedVideos[index];
                    if (kDebugMode) {
                      print(video);
                    }
                    return VideoDisplay(
                      thumbnail: video,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
