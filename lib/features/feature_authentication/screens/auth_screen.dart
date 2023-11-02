import 'package:agrichapp/features/feature_authentication/widgets/sign_in.dart';
import 'package:agrichapp/features/feature_authentication/widgets/sign_up.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {

  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Register'),
    Tab(text: 'Login'),
  ];
  late TabController tab = TabController(length: myTabs.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:context.background,
        child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.05),
              child: Text(
                'Agrich 1.0',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            TabBar(
              tabs: myTabs,
              dividerColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              controller: tab,
            ),
            Expanded(
              child: TabBarView(
                controller: tab,
                children: const <Widget>[
                  SignUp(),
                  SignIn(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
