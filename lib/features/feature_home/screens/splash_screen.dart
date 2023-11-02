import 'package:agrichapp/resources/app_colours.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    final TypewriterAnimatedText splashscreenText = TypewriterAnimatedText(
      speed: const Duration(milliseconds: 150),
      cursor: "",
      "Agrich 1.0",
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/tree.png',
              alignment: Alignment.center,
              scale: 3,
            ),
            AnimatedTextKit(
              animatedTexts: [splashscreenText],
              isRepeatingAnimation: false,
            ),
          ],
        ),
      ),
    );
  }
}
