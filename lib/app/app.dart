import 'package:agrichapp/features/feature_profile/screens/edit_profile.dart';
import 'package:agrichapp/helpers/navigation_helper.dart';
import 'package:agrichapp/resources/theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/farmer.jpeg"), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      // home:const EditProfile(),
      initialRoute: Navigation.entry,
      onGenerateRoute: Navigation.onGenerateRoute,
    );
  }
}
