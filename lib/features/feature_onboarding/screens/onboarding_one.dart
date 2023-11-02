import 'package:agrichapp/features/feature_onboarding/screens/onboarding_three.dart';
import 'package:agrichapp/features/feature_onboarding/screens/onboarding_two.dart';
import 'package:agrichapp/helpers/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      body: PageView(
        controller: controller,
        children: const <Widget>[
          OnboardingOne(),
          OnboardingTwo(),
          OnboardingThree(),
        ],
      ),
    );
  }
}

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

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
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).width * 0.15),
                    child: Text(
                      'Modern farming is an advanced agricultural practice that utilizes technology  and scientific methods to maximize crop yield.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const OnboardingTwo(),
                            type: PageTransitionType.rightToLeftJoined,
                            ctx: context,
                            childCurrent: this));
                  },
                  icon: Icon(
                    Icons.arrow_circle_right_outlined,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  iconSize: 45,
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
                  color: Theme.of(context).primaryColor,
                ),
                Icon(
                  Icons.circle,
                  color: Theme.of(context).disabledColor,
                ),
                Icon(
                  Icons.circle,
                  color: Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
