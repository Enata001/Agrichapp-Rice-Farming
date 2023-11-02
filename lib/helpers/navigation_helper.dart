import 'package:agrichapp/app/app.dart';
import 'package:agrichapp/features/feature_authentication/screens/otp_screen.dart';
import 'package:agrichapp/features/feature_authentication/screens/auth_screen.dart';
import 'package:agrichapp/features/feature_dashboard/screens/dashboard.dart';
import 'package:agrichapp/features/feature_onboarding/screens/onboarding_one.dart';
import 'package:agrichapp/features/feature_onboarding/screens/onboarding_three.dart';
import 'package:agrichapp/features/feature_onboarding/screens/onboarding_two.dart';
import 'package:agrichapp/features/feature_profile/screens/edit_profile.dart';
import 'package:agrichapp/index_page.dart';
import 'package:flutter/material.dart';

class Navigation {
  Navigation._();

  static const entry = "/";
  static const onboardOne = "/one";
  static const onboardTwo = "/two";
  static const onboardThree = "/three";
  static const startUp ="/auth";
  static const otp = "/otp";
  static const home = "/home";
  static const dashboard = "/dashboard";
  static const editProfile = "/profile";

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case entry:
        return AppRoute(page: const IndexPage());
        
      case onboardOne:
        return AppRoute(page: const OnboardingOne());
        
      case onboardTwo:
        return AppRoute(page: const OnboardingTwo());
        
      case onboardThree:
        return AppRoute(page: const OnboardingThree());
        
      case startUp:
        return AppRoute(page: const AuthScreen());
        
      case otp:
        return AppRoute(page:const OneTimePinScreen());

      case home:
        return AppRoute(page: const DashBoard());

      case editProfile:
        return AppRoute(page: const EditProfile());
        
      default:
        return AppRoute(page: const ErrorRoute());
    }
  }
}

// custom form of MaterialPageRoute( builder: (context) => *route*))
class AppRoute extends PageRouteBuilder {
  final Widget page;

  AppRoute({required this.page})
      : super(pageBuilder: (context, animation, secondaryAnimation) {
          return page;
        });
}

// error screen for unimplemented routes
class ErrorRoute extends StatelessWidget {
  const ErrorRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("This page does not exist"),
      ),
    );
  }
}
