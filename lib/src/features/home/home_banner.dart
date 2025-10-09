import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sozodesktop/src/features/home/model/banner_model.dart';

import 'bloc/home_bloc.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerDataModel> bannerItems;
  const BannerCarousel({super.key, required this.bannerItems});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel>
    with TickerProviderStateMixin {
  int _current = 0;

  late AnimationController _fadeController;
  late AnimationController _slideController;

  // Hover states
  bool isWatchNowHovered = false;
  bool isMoreInfoHovered = false;
  bool isBookmarkHovered = false;


  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _playAnimations();

  }

  void _playAnimations() {
    _fadeController.reset();
    _slideController.reset();
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
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.bannerItems.length>10?10:widget.bannerItems.length,
          itemBuilder: (context, index, realIndex) {
            final item = widget.bannerItems[index];

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  // Background image
                  SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: item.bannerImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.85),
                            Colors.black.withOpacity(0.4),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 1.0],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),

                  // Animated content
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: FadeTransition(
                      opacity: _fadeController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _slideController,
                          curve: Curves.easeOut,
                        )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Info Row
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
                                  item.season!+" "+item.seasonYear!.toString(),
                                  style: GoogleFonts.roboto(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.episodes.toString(),
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
                              item.title!.english.toString(),
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.7),
                                    blurRadius: 6,
                                    offset: const Offset(1, 1),
                                  )
                                ],
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Description
                            SizedBox(
                              width: 500,
                              child: Text(
                                item.description!,
                                style: GoogleFonts.roboto(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Buttons Row
                            Row(
                              children: [
                                // Watch Now
                                MouseRegion(
                                  onEnter: (_) =>
                                      setState(() => isWatchNowHovered = true),
                                  onExit: (_) =>
                                      setState(() => isWatchNowHovered = false),
                                  child: AnimatedContainer(
                                    duration:
                                    const Duration(milliseconds: 200),
                                    transform: Matrix4.identity()
                                      ..scale(isWatchNowHovered ? 1.07 : 1.0),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isWatchNowHovered
                                            ? Colors.red[700]
                                            : Colors.redAccent,
                                        elevation:
                                        isWatchNowHovered ? 10 : 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 22,
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: isWatchNowHovered ? 24 : 22,
                                      ),
                                      label: const Text(
                                        "Watch Now",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // More Info
                                MouseRegion(
                                  onEnter: (_) =>
                                      setState(() => isMoreInfoHovered = true),
                                  onExit: (_) =>
                                      setState(() => isMoreInfoHovered = false),
                                  child: AnimatedContainer(
                                    duration:
                                    const Duration(milliseconds: 200),
                                    transform: Matrix4.identity()
                                      ..scale(isMoreInfoHovered ? 1.07 : 1.0),
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: isMoreInfoHovered
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 22,
                                          vertical: 14,
                                        ),
                                      ),
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.info_outline,
                                        color: Colors.black87,
                                        size: isMoreInfoHovered ? 24 : 22,
                                      ),
                                      label: const Text(
                                        "More Info",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // Bookmark
                                MouseRegion(
                                  onEnter: (_) =>
                                      setState(() => isBookmarkHovered = true),
                                  onExit: (_) =>
                                      setState(() => isBookmarkHovered = false),
                                  child: AnimatedContainer(
                                    duration:
                                    const Duration(milliseconds: 200),
                                    transform: Matrix4.identity()
                                      ..scale(isBookmarkHovered ? 1.15 : 1.0),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: isBookmarkHovered
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.9),
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(14),
                                      ),
                                      onPressed: () {},
                                      child: Icon(
                                        isBookmarkHovered
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: isBookmarkHovered
                                            ? Colors.redAccent
                                            : Colors.black87,
                                        size: isBookmarkHovered ? 24 : 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 900),
            autoPlayCurve: Curves.easeInOutCubic,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
              _playAnimations();
            },
          ),
        ),

        const SizedBox(height: 18),

        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.bannerItems.length>10?10:widget.bannerItems.length, (index) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index ? Colors.white : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}

