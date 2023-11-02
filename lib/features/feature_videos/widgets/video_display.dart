import 'package:agrichapp/features/feature_videos/screens/video_player.dart';
import 'package:agrichapp/features/feature_videos/widgets/video_skeleton.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../models/thumbnail.dart';

class VideoDisplay extends StatelessWidget {
  const VideoDisplay({
    super.key,
    required this.thumbnail,
    this.saveVideo
  });

  final Thumbnail thumbnail;
  final VoidCallback? saveVideo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        saveVideo?.call();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => VideoPlayer(
              name: basenameWithoutExtension(thumbnail.name),
              category: thumbnail.category,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.clearGreen,
              blurStyle: BlurStyle.outer,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                10,
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: thumbnail.path,
                    placeholder: (context, url) {
                      return const Skeleton(
                        height: 176,
                      );
                    },
                  ),
                  const Positioned(
                    top: 65,
                    left: 120,
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 75,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(
                basenameWithoutExtension(
                  thumbnail.name,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
