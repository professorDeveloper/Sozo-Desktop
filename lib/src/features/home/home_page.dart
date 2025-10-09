import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:sozodesktop/src/features/home/home_banner.dart';
import 'package:sozodesktop/src/features/home/bloc/home_bloc.dart';
import 'package:sozodesktop/src/features/home/model/home_anime_model.dart';
import '../../core/constants/app_color.dart';
import 'dart:ui';

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

    // ✅ Buni shunday yoz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeBloc>().add(FetchBanners());
      }
    });
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
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            );
          } else if (state is HomeLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // BannerCarousel with banners from API
                  BannerCarousel(bannerItems: state.banners),
                  const SizedBox(height: 20),
                  // Trending Now with trending data from API
                  _buildReccommendedSection( state.reccommended),
                  _buildMostFavouriteSection(state.mostFavourite),
                  _buildTrendingSection(state.trending),
                  // Recently Added with mostFavourite data from API

                  // Footer
                  _buildFooterSection(),
                ],
              ),
            );
          } else if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Xato yuz berdi: ${state.message}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(FetchBanners());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      'Qayta urinish',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink(); // Initial state
        },
      ),
    );
  }

  Widget _buildReccommendedSection(List<HomeAnimeModel> trendingItems) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Reccommended For You",
                style: GoogleFonts.daysOne(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 300,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: trendingItems.isEmpty
                  ? const Center(
                child: Text(
                  'No trending items available',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trendingItems.length > 20 ? 20 : trendingItems.length,
                itemBuilder: (context, index) {
                  final item = trendingItems[index];
                  return _HoverableListItem(
                    margin: const EdgeInsets.only(right: 22),
                    width: 140,
                    item: item,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMostFavouriteSection(List<HomeAnimeModel> trendingItems) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Most Favourite",
                style: GoogleFonts.daysOne(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 300,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: trendingItems.isEmpty
                  ? const Center(
                child: Text(
                  'No trending items available',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trendingItems.length > 20 ? 20 : trendingItems.length,
                itemBuilder: (context, index) {
                  final item = trendingItems[index];
                  return _HoverableListItem(
                    margin: const EdgeInsets.only(right: 22),
                    width: 140,
                    item: item,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTrendingSection(List<HomeAnimeModel> trendingItems) {
    return Container(
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
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "See All",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 300,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: trendingItems.isEmpty
                  ? const Center(
                child: Text(
                  'No trending items available',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: trendingItems.length > 20 ? 20 : trendingItems.length,
                itemBuilder: (context, index) {
                  final item = trendingItems[index];
                  return _HoverableListItem(
                    margin: const EdgeInsets.only(right: 22),
                    width: 140,
                    item: item,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildFooterSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768;

        return Container(
          margin: const EdgeInsets.only(top: 60),
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
      padding: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: isDesktop
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '© 2025 Sozo. All rights reserved.',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
          const Text(
            'give me a star on github ⭐ and follow us on telegram 🦄',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
        ],
      )
          : const Column(
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

class _HoverableListItem extends StatefulWidget {
  final EdgeInsets margin;
  final double width;
  final HomeAnimeModel item;

  const _HoverableListItem({
    required this.margin,
    required this.width,
    required this.item,
  });

  @override
  State<_HoverableListItem> createState() => _HoverableListItemState();
}

class _HoverableListItemState extends State<_HoverableListItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    print(item.coverImage.toString()  );
    final title = item.title?.english ?? 'Unknown Title';
    final year = item.seasonYear?.toString() ?? 'N/A';
    final type = item.format ?? 'TV';
    final imageUrl = (item.coverImage?.medium != null && item.coverImage!.medium!.isNotEmpty)
        ? item.coverImage!.extraLarge!
        : 'https://s4.anilist.co/file/anilistcdn/media/anime/banner/1-OquNCNB6srGe.jpg';

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..scale(isHovered ? 1.05 : 1.0)
          ..translate(0.0, isHovered ? -5.0 : 0.0),
        margin: widget.margin,
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: isHovered
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
                    : [],
                image: DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: isHovered
                  ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(height: 7),
            SizedBox(
              height: 20,
              child: Marquee(
                text: title,
                style: GoogleFonts.daysOne(
                  color: isHovered ? Colors.white : Colors.white,
                  fontSize: 14,
                  fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 40.0,
                velocity: 30.0,
                pauseAfterRound: const Duration(seconds: 1),
                startPadding: 0.0,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: isHovered ? Colors.white : Colors.white70,
                  size: 13,
                ),
                const SizedBox(width: 2),
                Text(
                  year,
                  style: GoogleFonts.rubik(
                    color: isHovered ? Colors.white : Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.movie,
                  color: isHovered ? Colors.white : Colors.white70,
                  size: 13,
                ),
                const SizedBox(width: 4),
                Text(
                  type,
                  style: GoogleFonts.rubik(
                    color: isHovered ? Colors.white : Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverableRecentItem extends StatefulWidget {
  final double width;
  final EdgeInsets margin;
  final HomeAnimeModel item;

  const _HoverableRecentItem({
    required this.width,
    required this.margin,
    required this.item,
  });

  @override
  State<_HoverableRecentItem> createState() => _HoverableRecentItemState();
}

class _HoverableRecentItemState extends State<_HoverableRecentItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final imageUrl = item.bannerImage ?? 'https://s4.anilist.co/file/anilistcdn/media/anime/banner/1-OquNCNB6srGe.jpg';

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..scale(isHovered ? 1.05 : 1.0)
          ..translate(0.0, isHovered ? -8.0 : 0.0),
        width: widget.width,
        margin: widget.margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: isHovered
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ]
              : [],
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: isHovered
            ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        )
            : null,
      ),
    );
  }
}