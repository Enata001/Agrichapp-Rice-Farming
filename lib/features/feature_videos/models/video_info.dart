import 'dart:convert';
import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:better_player/better_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Video {
  final String name;
  final String path;
  late BetterPlayerController betterPlayerController;
  late AuthProvider authProvider;

  Video({required this.name, required this.path});

  Future<void> init() async {
    Reference ref =
        FirebaseStorage.instance.ref().child(path).child('$name.mp4');
    String url = await ref.getDownloadURL();

    BetterPlayerCacheConfiguration betterPlayerCacheConfiguration =
        BetterPlayerCacheConfiguration(
      maxCacheFileSize: 100 * 1024 * 1024,
      maxCacheSize: 100 * 1024 * 1024,
      useCache: true,
      key: url,
    );
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      url,
      cacheConfiguration: betterPlayerCacheConfiguration,
    );
    BetterPlayerConfiguration betterPlayerConfiguration =
         const BetterPlayerConfiguration(
      autoPlay: true,
      aspectRatio: 16 / 9,
      expandToFill: true,
      autoDetectFullscreenDeviceOrientation: true,
      autoDispose: true,
      showPlaceholderUntilPlay: true,
      fit: BoxFit.contain,
      autoDetectFullscreenAspectRatio: true,
      fullScreenByDefault: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableQualities: true,
        enableProgressBarDrag: true,
        enablePlayPause: true,
        enableMute: true,
        enableFullscreen: true,
        enableRetry: true,
        enableSkips: true,
        showControls: true,
          // customControlsBuilder: (BetterPlayerController controller, Function(bool) onPlayerVisibilityChanged) { return Row( children: const [ Text('next'), Icon(Icons.arrow_forward_sharp), ], ); })
        // customControlsBuilder: (controller, onPlayerVisibilityChanged) { return const Row( children: [ Text('next'), Icon(Icons.arrow_forward_sharp), ], ); }

    ),);
    betterPlayerController = BetterPlayerController(betterPlayerConfiguration,
        betterPlayerDataSource: betterPlayerDataSource);
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'path': path,
  //   };
  // }
  //
  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      name: json['name'],
      path: json['path'],
    );
  }
  //
  factory Video.fromString({required String data}) {
    return Video.fromJson(
      jsonDecode(data),
    );
  }
  //
  // @override
  // String toString() {
  //   return jsonEncode(toJson());
  // }
  //
  // void dispose() {
  //   betterPlayerController.dispose();
  // }
}

//

