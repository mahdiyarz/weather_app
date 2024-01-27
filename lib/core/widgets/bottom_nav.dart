import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  PageController pageController;
  BottomNav({required this.pageController, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      color: Colors.blueGrey.shade400,
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                color: Colors.white,
                onPressed: () {
                  pageController.animateToPage(0,
                      duration: const Duration(microseconds: 300),
                      curve: Curves.easeInExpo);
                },
                icon: const Icon(Icons.home)),
            IconButton(
                color: Colors.white,
                onPressed: () {
                  pageController.animateToPage(1,
                      duration: const Duration(microseconds: 300),
                      curve: Curves.easeInExpo);
                },
                icon: const Icon(Icons.bookmark)),
          ],
        ),
      ),
    );
  }
}
