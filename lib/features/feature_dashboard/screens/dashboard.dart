import 'package:agrichapp/features/feature_dashboard/widgets/profile.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:agrichapp/features/feature_dashboard/widgets/categories.dart';
import 'package:agrichapp/features/feature_dashboard/widgets/home.dart';
import 'package:agrichapp/features/feature_dashboard/widgets/tips.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedPage = 0;
  bool _showBottomBar = true;
  bool _isScrollingDown = false;
  ScrollController _scrollBottomBarController = ScrollController();
  double _bottomBarHeight = 75;
  double _bottomBarOffset = 0;
  final List<Widget> _pages = [
    const Home(),
    Categories(),
    Tips(),
    const Profile()
  ];

  void scrolling() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          _isScrollingDown = true;
          hideBottomBar();
        }
      }

      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollingDown) {
          _isScrollingDown = false;
          showBottomBar();
        }
      }
    });
  }

  void showBottomBar() {
    setState(() {
      _showBottomBar = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _showBottomBar = false;
    });
  }

  @override
  void initState() {
    super.initState();
    scrolling();
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: context.background,
        child: SingleChildScrollView(
          child: _pages[_selectedPage],
        ),
      ),
      bottomNavigationBar: _showBottomBar
          ? Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurStyle: BlurStyle.outer,
                    blurRadius: 25,
                  ),
                ],
              ),
              child: GNav(
                gap: 0,
                activeColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(10),
                iconSize: 32,
                textSize: 13,
                style: GnavStyle.oldSchool,
                color: Colors.black,
                onTabChange: (index) {
                  setState(() {
                    _selectedPage = index;
                  });
                },
                tabs: const [
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.widgets_outlined,
                    text: 'Categories',
                  ),
                  GButton(
                    icon: Icons.lightbulb_outlined,
                    text: 'Tips',
                  ),
                  GButton(
                    icon: Icons.person_outline,
                    text: 'Profile',
                  )
                ],
              ),
            )
          : Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
            ),
    );
  }
}
