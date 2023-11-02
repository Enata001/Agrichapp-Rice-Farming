import 'package:agrichapp/app/user_auth_check.dart';
import 'package:agrichapp/features/feature_home/screens/splash_screen.dart';
import 'package:agrichapp/features/feature_onboarding/screens/onboarding_one.dart';
import 'package:agrichapp/helpers/cache_helper.dart';
import 'package:agrichapp/resources/dimension.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: initializeApp(),
        builder: (context, snapshot) {
          bool hasOnboarded = snapshot.data ?? false;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          return hasOnboarded ? const UserAuthCheck() : const Onboarding();
        },
      ),
    );
  }

  Future<bool> initializeApp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool res = await Future.delayed(Dimensions.splashDelay, () {
      bool isOnboarded = pref.getBool(CacheConstants.HAS_ONBOARDED) ?? false;
      return isOnboarded;
    });
    return res;
  }
}
