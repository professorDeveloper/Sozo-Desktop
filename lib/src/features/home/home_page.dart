import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart' as CarouselController;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart' as CarouselController;
import 'package:marquee/marquee.dart';
import '../../core/constants/app_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  bool isLogoHovered = false;
  int _current = 0;
  var bannerItems = [
    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/1-OquNCNB6srGe.jpg",
    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/33-g7HwYRVm0ZkN.jpg",
    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/n55-GkpzkjVbaMxb.jpg",
    "https://s4.anilist.co/file/anilistcdn/media/anime/banner/77-T4VUflM5o47a.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              child: CarouselSlider.builder(
                itemCount: bannerItems.length,
                carouselController: CarouselSliderController(),
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Stack(
                      children: [
                        // Background image
                        SizedBox(
                          height: 500,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: bannerItems[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Gradient overlay + content
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(16),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  // juda qoraroq past
                                  Colors.black.withOpacity(0.6),
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.3, 0.6, 1.0],
                                // qora yuqoriga ko‘tariladi
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Top info row
                                Row(
                                  children: [
                                    Text(
                                      "TV",
                                      style: GoogleFonts.roboto(
                                        color: Colors.redAccent,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Spring 2024",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "10 Episodes",
                                      style: GoogleFonts.roboto(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Title
                                Text(
                                  "Girls Band Cry",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // Description
                                Text(
                                  "The main character drops out of high school in her second year, "
                                  "and aims at entering a university while working alone in Tokyo. "
                                  "A girl is betrayed by her friends and doesn’t know what to do...",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white70,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 12),

                                // Buttons row
                                Row(
                                  children: [
                                    // Watch now
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        "Watch now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // More info
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.info_outline,
                                        color: Colors.black87,
                                      ),
                                      label: const Text(
                                        "More info",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // Bookmark
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide.none,
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(12),
                                      ),
                                      onPressed: () {},
                                      child: const Icon(
                                        Icons.bookmark_border,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 500,
                  viewportFraction: 0.95,
                  initialPage: 0,
                  autoPlay: true,

                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(bannerItems.length, (index) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? AppColors.White
                          : AppColors.Gray2,
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Trending Now",
                          style: GoogleFonts.daysOne(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 300,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 22),
                              width: 140,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 230,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          bannerItems[index % bannerItems.length],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  SizedBox(
                                    height: 20,
                                    child: Marquee(
                                      text: "Hunter x Hunter - The Legend Continues...",
                                      style: GoogleFonts.daysOne(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      scrollAxis: Axis.horizontal,
                                      blankSpace: 40.0,
                                      velocity: 30.0,
                                      pauseAfterRound: Duration(seconds: 1),
                                      startPadding: 0.0,
                                    ),
                                  ),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(CupertinoIcons.calendar,color: Colors.white70, size: 13,),
                                      SizedBox(width: 2),
                                      Text("2024",style: GoogleFonts.rubik(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),),
                                      Spacer(),
                                      Icon(CupertinoIcons.film_fill,color: Colors.white70, size: 13,),
                                      SizedBox(width: 4),
                                      Text("Movie",style: GoogleFonts.rubik(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),),

                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                          itemCount: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Recently Added",
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 230,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 140,
                              margin: EdgeInsets.only(right: 18, bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    bannerItems[index % bannerItems.length],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                          itemCount: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildFooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768;

        return Container(
          margin: EdgeInsets.only(top: 60),
          padding: EdgeInsets.fromLTRB(
            isDesktop ? 80 : (isTablet ? 40 : 24),
            60,
            isDesktop ? 80 : (isTablet ? 40 : 24),
            40,
          ),
          child: Column(children: [_buildFooterBottom(constraints)]),
        );
      },
    );
  }

  Widget _buildFooterBottom(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;

    return Container(
      padding: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2025 Sozo. All rights reserved.',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
                Text(
                  'give me a star on github ⭐ and follow us on telegram 🐦',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            )
          : Column(
              children: [
                Text(
                  '© 2024 AnimeStream. All rights reserved.',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Made with ❤️ for anime fans',
                  style: TextStyle(color: Colors.white60, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }
}
