import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sozodesktop/src/core/constants/app_color.dart';
import 'package:sozodesktop/src/core/constants/app_icons.dart';
import 'package:sozodesktop/src/features/collections/collections_page.dart';
import 'package:sozodesktop/src/features/tvshows/tvshows_page.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';

import '../../categories/categories_page.dart';
import '../../home/home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedNavIndex = 0;
  int? hoveredNavIndex;
  bool isLogoHovered = false;
  bool isProfileHovered = false;
  bool isSearchHovered = false;

  final List<Widget> pages = [
    const HomePage(),
    const CategoriesPage(),
    const SearchScreen(),
    const CollectionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(child: pages[selectedNavIndex]),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.38, vertical: 10),
        child: CrystalNavigationBar(
          height: 55,
          currentIndex: selectedNavIndex,
          onTap: (index) {
            setState(() {
              selectedNavIndex = index;
            });
          },

          backgroundColor: const Color(0x8C101115),
          items: [
            CrystalNavigationBarItem(
              icon: CupertinoIcons.home,
              selectedColor: Colors.white,
              unselectedColor: Colors.grey,
              badge: isLogoHovered
                  ? const Badge(
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      largeSize: 16,
                      smallSize: 12,
                    )
                  : null,
            ),
            CrystalNavigationBarItem(
              icon: CupertinoIcons.search,
              selectedColor: Colors.white,
              unselectedColor: Colors.grey,
              badge: isProfileHovered
                  ? const Badge(
                backgroundColor: Colors.red,
                textColor: Colors.white,
                largeSize: 16,
                smallSize: 12,
              )
                  : null,
            ),
            CrystalNavigationBarItem(
              icon: CupertinoIcons.square_grid_2x2,
              selectedColor: Colors.white,
              unselectedColor: Colors.grey,
              badge: isSearchHovered
                  ? const Badge(
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      largeSize: 16,
                      smallSize: 12,
                    )
                  : null,
            ),
            CrystalNavigationBarItem(
              icon: CupertinoIcons.settings,
              selectedColor: Colors.white,
              unselectedColor: Colors.grey,
              badge: isProfileHovered
                  ? const Badge(
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      largeSize: 16,
                      smallSize: 12,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// Home Page

// Categories Page
