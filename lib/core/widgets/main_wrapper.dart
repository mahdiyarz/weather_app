import 'package:flutter/material.dart';
import 'package:weather_app/core/widgets/app_background.dart';
import 'package:weather_app/core/widgets/bottom_nav.dart';
import 'package:weather_app/features/feature_bookmark/presentation/screens/bookmark_screen.dart';
import 'package:weather_app/features/feature_weather/presentation/screens/home_screen.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewWidget = [
      const HomeScreen(),
      BookmarkScreen(
        pageController: pageController,
      ),
    ];

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNav(pageController: pageController),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AppBackground.getBackGroundImage(),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.sizeOf(context).height,
        child: PageView(
          controller: pageController,
          children: pageViewWidget,
        ),
      ),
    );
  }
}
