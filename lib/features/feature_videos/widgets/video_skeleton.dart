import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const Skeleton({
    super.key, this.height, this.width,this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width??double.infinity,
      height: height??200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color??Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 2),
    );
  }
}

class VideoShimmerSkeleton extends StatelessWidget {
  const VideoShimmerSkeleton({
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
            const Skeleton(
              height: 180,
            ),
            const SizedBox(
              height: 5,
            ),
            Skeleton(
              height: 15,
              width: MediaQuery.sizeOf(context).width * 0.8,
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
