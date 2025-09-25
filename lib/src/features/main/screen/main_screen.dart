import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sozodesktop/src/core/constants/app_icons.dart';
import 'package:sozodesktop/src/features/collections/collections_page.dart';
import 'package:sozodesktop/src/features/tvshows/tvshows_page.dart';

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
    const TvshowsPage(),
    const CollectionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar
          _buildAppBar(),
          // Page Content
          Expanded(
            child: pages[selectedNavIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3A0B0B),
            Color(0xFF260303),
            Color(0xFF100707),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      child: Row(
        children: [
          // Logo Section
          _buildHoverableLogo(),
          const SizedBox(width: 60),
          // Navigation Items
          Expanded(
            child: Row(
              children: [
                _buildHoverableNavItem(
                  icon: AppIcons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildHoverableNavItem(
                  icon: AppIcons.categories,
                  label: 'Categories',
                  index: 1,
                ),
                _buildHoverableNavItem(
                  icon: AppIcons.tv,
                  label: 'TV Shows',
                  index: 2,
                ),
                _buildHoverableNavItem(
                  icon: null,
                  label: 'Collections',
                  index: 3,
                  customIcon: const Icon(
                    Icons.video_library_outlined,
                    size: 18,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Right Side Actions
          _buildHoverableRightActions(),
        ],
      ),
    );
  }

  Widget _buildHoverableLogo() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isLogoHovered = true),
      onExit: (_) => setState(() => isLogoHovered = false),
      child: GestureDetector(
        onTap: () => setState(() => selectedNavIndex = 0),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isLogoHovered ? const Color(0xFFFF4757) : const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(6),
                boxShadow: isLogoHovered
                    ? [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: AnimatedScale(
                scale: isLogoHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Image.asset('assets/images/img.png'),
              ),
            ),
            const SizedBox(width: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: isLogoHovered ? 0.5 : -0.5,
              ),
              child: const Text('Sozo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoverableNavItem({
    String? icon,
    required String label,
    required int index,
    Widget? customIcon,
  }) {
    final isSelected = selectedNavIndex == index;
    final isHovered = hoveredNavIndex == index;

    return Padding(
      padding: const EdgeInsets.only(right: 48),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => hoveredNavIndex = index),
        onExit: (_) => setState(() => hoveredNavIndex = null),
        child: GestureDetector(
          onTap: () => setState(() => selectedNavIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0x22DC2626)
                  : isHovered
                  ? const Color(0x11ffffff)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: const Color(0xFFDC2626).withOpacity(0.3))
                  : isHovered
                  ? Border.all(color: Colors.white.withOpacity(0.2))
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: isHovered ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: icon != null
                          ? SvgPicture.asset(
                        icon,
                        width: 18,
                        height: 18,
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? const Color(0xFFDC2626)
                              : isHovered
                              ? Colors.white
                              : Colors.white70,
                          BlendMode.srcIn,
                        ),
                      )
                          : Icon(
                        Icons.video_library_outlined,
                        size: 18,
                        color: isSelected
                            ? const Color(0xFFDC2626)
                            : isHovered
                            ? Colors.white
                            : Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : isHovered
                            ? FontWeight.w500
                            : FontWeight.w400,
                        color: isSelected
                            ? const Color(0xFFDC2626)
                            : isHovered
                            ? Colors.white
                            : Colors.white70,
                      ),
                      child: Text(label),
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 2,
                  width: isSelected ? 40 : isHovered ? 20 : 0,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFDC2626)
                        : isHovered
                        ? Colors.white.withOpacity(0.5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHoverableRightActions() {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isProfileHovered = true),
          onExit: (_) => setState(() => isProfileHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isProfileHovered ? const Color(0x55ffffff) : const Color(0x33ffffff),
              borderRadius: BorderRadius.circular(8),
              border: isProfileHovered ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
            ),
            child: Row(
              children: [
                AnimatedScale(
                  scale: isProfileHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: SvgPicture.asset(
                    'assets/icons/profile.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'My Profile',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => isSearchHovered = true),
          onExit: (_) => setState(() => isSearchHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSearchHovered ? const Color(0x22ffffff) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSearchHovered ? Border.all(color: Colors.white.withOpacity(0.2)) : null,
            ),
            child: AnimatedScale(
              scale: isSearchHovered ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.search,
                color: isSearchHovered ? Colors.white : Colors.white70,
                size: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Home Page

// Categories Page
