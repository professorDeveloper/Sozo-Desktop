import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_color.dart';
import 'about_screen.dart';
import 'appearance_screen.dart';
import 'general_settings_screen.dart';
import 'playback_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PlaybackSettingsScreen(),
    const GeneralSettingsScreen(),
    const AppearanceSettingsContent(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar Navigation
            Container(
              width: 240,
              decoration: BoxDecoration(
                color: const Color(0xFF17171C),
                border: Border(
                  right: BorderSide(
                    color: Colors.white.withOpacity(0.06),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.settings_solid,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Settings',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildNavItem(
                          CupertinoIcons.play_circle,
                          'Playback',
                          0,
                        ),
                        _buildNavItem(
                          CupertinoIcons.square_grid_2x2,
                          'General',
                          1,
                        ),
                        _buildNavItem(
                          CupertinoIcons.paintbrush,
                          'Appearance',
                          2,
                        ),
                        _buildNavItem(CupertinoIcons.info_circle, 'About', 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: _screens[_selectedIndex],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    final isActive = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.Red.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isActive ? AppColors.Red : Colors.white.withOpacity(0.6),
          size: 18,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: isActive ? AppColors.Red : Colors.white.withOpacity(0.6),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        onTap: () => setState(() => _selectedIndex = index),
      ),
    );
  }
}
