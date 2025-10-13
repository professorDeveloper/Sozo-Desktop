import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_color.dart';

class BrowseAnimePage extends StatefulWidget {
  const BrowseAnimePage({super.key});

  @override
  State<BrowseAnimePage> createState() => _BrowseAnimePageState();
}

class _BrowseAnimePageState extends State<BrowseAnimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(children: [_buildHeader(), _buildContent()]),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Row(
        children: [
          Text(
            'Browse Anime',
            style: GoogleFonts.daysOne(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container();
  }
}
