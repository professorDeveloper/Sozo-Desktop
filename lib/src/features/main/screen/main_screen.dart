import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sozodesktop/src/core/constants/app_color.dart';
import 'package:sozodesktop/src/core/constants/app_icons.dart';
import 'package:sozodesktop/src/features/search/bloc/search_bloc.dart';
import 'package:sozodesktop/src/features/search/screen/search_screen.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozodesktop/src/features/tv/bloc/channel_bloc.dart';
import 'package:sozodesktop/src/features/tv/tv_page.dart';
import '../../../di/get_it.dart';
import '../../categories/categories_page.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/home_page.dart';
import '../../settings/settings_screen.dart';

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
    BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: const HomePage(),
    ),
    BlocProvider(
      create: (context) => getIt<SearchBloc>(),
      child: const SearchScreen(),
    ),

    BlocProvider(
      create: (context) => getIt<ChannelBloc>(),
      child: const TvScreen(), // Reused for settings; adjust if needed
    ),
    BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: const BrowseAnimePage(),
    ),
    BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: const SettingsScreen(), // Reused for settings; adjust if needed
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: pages[selectedNavIndex]),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: IntrinsicWidth(
                child: CrystalNavigationBar(
                  height: 45,
                  // yoki default ham qoldirsa bo‘ladi
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
                      icon: CupertinoIcons.tv,
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
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }
}

// Home Page

// Categories Page
