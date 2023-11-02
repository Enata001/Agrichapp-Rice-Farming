import 'package:agrichapp/features/feature_authentication/models/user_data.dart';
import 'package:agrichapp/helpers/cache_helper.dart';
import 'package:agrichapp/helpers/extensions.dart';
import 'package:agrichapp/features/feature_tips/models/card_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature_videos/models/thumbnail.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences? sharedPreferences;

  AuthProvider({required this.sharedPreferences}) {
    userData = sharedPreferences?.getUserData();
  }

  UserData? userData;

  Future saveUserOnboarded({required bool hasUserOnboarded}) async {
    await sharedPreferences?.setBool(
        CacheConstants.HAS_ONBOARDED, hasUserOnboarded);
  }

  Future saveUserinfo({required UserData user}) async {
    String stringUserInfo = user.toString();
    await sharedPreferences?.setString(
        CacheConstants.USER_DATA, stringUserInfo);
  }

  Future clearUserInfo() async {
    await sharedPreferences?.setString(CacheConstants.USER_DATA, "{}");
  }

  Future saveViewedVideos({required Thumbnail video}) async {
    String stringVideo = video.toString();
    final videos = await getViewedVideos();

    if (!videos.contains(stringVideo)) {
      videos.add(stringVideo);
      await sharedPreferences
          ?.setStringList(CacheConstants.VIEWED_VIDEOS, videos)
          .then((value) {
        if (kDebugMode) {
          print(videos);
        }
      });
    }
    if (videos.contains(stringVideo)) {
      videos.remove(stringVideo);
      videos.add(stringVideo);
      await sharedPreferences
          ?.setStringList(CacheConstants.VIEWED_VIDEOS, videos)
          .then((value) {
        if (kDebugMode) {
          print(videos);
          print('videos saved');
        }
      });
    }
  }

  Future<List<String>> getViewedVideos() async {
    return sharedPreferences?.getStringList(CacheConstants.VIEWED_VIDEOS) ?? [];
  }

  Future clearVideoInfo() async {
    await sharedPreferences?.setStringList(CacheConstants.VIEWED_VIDEOS, []);
  }


  Future saveTip({required CardInfo info}) async {
    String stringTip = info.toString();
    final tips = await getSavedTips();
    if (!tips.contains(stringTip)) {
      tips.add(stringTip);
      await sharedPreferences?.setStringList(CacheConstants.SAVED_TIPS, tips);
    }
  }

  Future<List<String>> getSavedTips() async {
    return sharedPreferences?.getStringList(CacheConstants.SAVED_TIPS) ?? [];
  }

  Future loadTip() async {
    final result = sharedPreferences?.getStringList(CacheConstants.DAILY_TIP);
    final now = DateTime.now();
    final today = DateFormat.yMMMd().format(now);
    if (result == null || result[0] != today) {
      DatabaseEvent event = await FirebaseDatabase.instance.ref('Tips').once();
      Map<dynamic, dynamic>? values = event.snapshot.value as Map;
      await sharedPreferences?.setStringList(CacheConstants.DAILY_TIP, []);
      await sharedPreferences?.setStringList(CacheConstants.DAILY_TIP,
          [today, values[today] ?? "No Tip Available"]);

      return values[today] ?? "No Tip Available";
    }
    return sharedPreferences
        ?.getStringList(CacheConstants.DAILY_TIP)?[1]
        .toString();
  }

  getTip(String tip) {
    return CardInfo.fromString(tip);
  }

  Future clearTips() async {
    await sharedPreferences?.setStringList(CacheConstants.SAVED_TIPS, []);
  }
}
