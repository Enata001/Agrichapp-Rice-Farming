import 'package:agrichapp/features/feature_videos/widgets/video_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TipShimmerSkeleton extends StatelessWidget {
  const TipShimmerSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Skeleton(
              height: 15,
              width: MediaQuery.sizeOf(context).width * 0.5,
            ),
            const SizedBox(
              height: 5,
            ),
            const Skeleton(
              height: 15,
            ),
            const SizedBox(
              height: 5,
            ),
            Skeleton(
              height: 15,
              width: MediaQuery.sizeOf(context).width * 0.8,
            ),
            const SizedBox(
              height: 5,
            ),
            Skeleton(
              height: 15,
              width: MediaQuery.sizeOf(context).width * 0.7,
            ),
          ],
        ),
      ),
    );
  }
}
