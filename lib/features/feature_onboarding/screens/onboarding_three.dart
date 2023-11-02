import 'package:agrichapp/features/feature_authentication/models/user_data.dart';
import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:agrichapp/features/feature_authentication/screens/auth_screen.dart';
import 'package:agrichapp/features/feature_onboarding/screens/onboarding_two.dart';
import 'package:agrichapp/helpers/cache_helper.dart';
import 'package:agrichapp/index_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingThree extends StatefulWidget {
  const OnboardingThree({super.key});

  @override
  State<OnboardingThree> createState() => _OnboardingThreeState();
}

class _OnboardingThreeState extends State<OnboardingThree> {
  late AuthProvider authProvider;

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.45,
            child: Image.asset(
              'assets/images/farmer.jpeg',
              fit: BoxFit.fitHeight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Text(
              'Modern Rice Farming',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: const OnboardingTwo(),
                        type: PageTransitionType.leftToRight,
                        ctx: context,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  iconSize: 45,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.sizeOf(context).width * 0.15),
                    child: Text(
                      'Modern farming is an advanced agricultural practice that utilizes technology  and scientific methods to maximize crop yield.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 120,
            margin: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.circle,
                  color: Theme.of(context).disabledColor,
                ),
                Icon(
                  Icons.circle,
                  color: Theme.of(context).disabledColor,
                ),
                Icon(
                  Icons.circle,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 20),
            width: 250,
            child: ElevatedButton(
              autofocus: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              onPressed: () {
                authProvider.saveUserOnboarded(hasUserOnboarded: true);

                Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                        child: const AuthScreen(),
                        type: PageTransitionType.rightToLeftWithFade),
                    (route) => false);
              },
              child: const Text(
                'Get Started',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
