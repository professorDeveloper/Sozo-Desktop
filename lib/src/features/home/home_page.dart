import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart' as CarouselController;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final _carouselController = CarouselController.CarouselSliderController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, String>> _heroAnimes = [
    {
      'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=1920&h=1080&fit=crop',
      'title': 'Attack on Titan',
      'subtitle': 'The Final Season',
      'description': 'The epic conclusion to humanity\'s struggle for survival against the mysterious Titans.',
      'genre': 'Action • Drama',
      'rating': '9.0',
      'year': '2023'
    },
    {
      'image': 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=1920&h=1080&fit=crop',
      'title': 'Demon Slayer',
      'subtitle': 'Swordsmith Village Arc',
      'description': 'Tanjiro and his companions face new challenges in the mysterious Swordsmith Village.',
      'genre': 'Action • Supernatural',
      'rating': '8.7',
      'year': '2023'
    },
    {
      'image': 'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=1920&h=1080&fit=crop',
      'title': 'Jujutsu Kaisen',
      'subtitle': 'Shibuya Incident',
      'description': 'The most dangerous arc yet as curses and sorcerers clash in downtown Tokyo.',
      'genre': 'Action • Supernatural',
      'rating': '8.9',
      'year': '2023'
    },
    {
      'image': 'https://images.unsplash.com/photo-1572177812156-58036aae439c?w=1920&h=1080&fit=crop',
      'title': 'One Piece',
      'subtitle': 'Wano Country Arc',
      'description': 'The Straw Hat Pirates take on Kaido in the ultimate battle for Wano\'s freedom.',
      'genre': 'Adventure • Comedy',
      'rating': '9.2',
      'year': '2023'
    },
  ];

  final List<Map<String, String>> _trendingAnimes = [
    {'title': 'Chainsaw Man', 'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=600&fit=crop', 'rating': '8.8'},
    {'title': 'Spy x Family', 'image': 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=400&h=600&fit=crop', 'rating': '8.6'},
    {'title': 'Mob Psycho 100', 'image': 'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400&h=600&fit=crop', 'rating': '9.1'},
    {'title': 'My Hero Academia', 'image': 'https://images.unsplash.com/photo-1572177812156-58036aae439c?w=400&h=600&fit=crop', 'rating': '8.5'},
    {'title': 'Tokyo Revengers', 'image': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400&h=600&fit=crop', 'rating': '8.3'},
    {'title': 'Blue Lock', 'image': 'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=400&h=600&fit=crop', 'rating': '8.4'},
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

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

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
      backgroundColor: const Color(0xFF0D0D0F),
      body: CustomScrollView(
        slivers: [
          _buildHeroSection(),
          _buildTrendingSection(),
          _buildRecommendedSection(),
          _buildFooterSection(),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1200;
          final isTablet = constraints.maxWidth > 768;
          final heroHeight = isDesktop ? 800.0 : (isTablet ? 600.0 : 500.0);

          return Container(
            height: heroHeight,
            child: Stack(
              children: [
                _buildCarousel(constraints),
                _buildHeroGradient(),
                _buildHeroContent(constraints),
                if (isDesktop) _buildNavigationControls(),
                _buildCarouselIndicators(constraints),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarousel(BoxConstraints constraints) {
    return CarouselSlider(
      carouselController: _carouselController,
      options: CarouselOptions(
        height: double.infinity,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 6),
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),
        autoPlayCurve: Curves.easeInOutQuart,
        enableInfiniteScroll: true,
        viewportFraction: 1.0,
        onPageChanged: (index, _) {
          setState(() => _currentIndex = index);
          _fadeController.reset();
          _slideController.reset();
          _fadeController.forward();
          _slideController.forward();
        },
      ),
      items: _heroAnimes.map((anime) => _buildCarouselItem(anime, constraints)).toList(),
    );
  }

  Widget _buildCarouselItem(Map<String, String> anime, BoxConstraints constraints) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: anime['image']!,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildImagePlaceholder(constraints),
          errorWidget: (context, url, error) => _buildImageError(constraints),
        ),
        _buildParallaxOverlay(),
      ],
    );
  }

  Widget _buildImagePlaceholder(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A1F), Color(0xFF0D0D0F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: isDesktop ? 60 : 40,
              height: isDesktop ? 60 : 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Color(0xFFE50914)),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Loading anime...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageError(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A1F), Color(0xFF0D0D0F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Color(0xFFE50914),
              size: isDesktop ? 60 : 40,
            ),
            SizedBox(height: 16),
            Text(
              'Failed to load image',
              style: TextStyle(
                color: Colors.white70,
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParallaxOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.0, 0.3, 0.7, 1.0],
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.8),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroGradient() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.4, 0.8, 1.0],
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.7),
              Color(0xFF0D0D0F),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroContent(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;
    final anime = _heroAnimes[_currentIndex];

    return Positioned(
      bottom: isDesktop ? 80 : (isTablet ? 60 : 40),
      left: isDesktop ? 80 : (isTablet ? 40 : 24),
      right: isDesktop ? 80 : (isTablet ? 40 : 24),
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAnimeMetadata(anime, constraints),
              SizedBox(height: isDesktop ? 16 : 12),
              _buildAnimeTitle(anime, constraints),
              SizedBox(height: isDesktop ? 12 : 8),
              _buildAnimeSubtitle(anime, constraints),
              SizedBox(height: isDesktop ? 20 : 16),
              _buildAnimeDescription(anime, constraints),
              SizedBox(height: isDesktop ? 32 : 24),
              _buildActionButtons(constraints),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimeMetadata(Map<String, String> anime, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFFE50914),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'NEW',
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 12 : 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(width: 12),
        Text(
          '⭐ ${anime['rating']}',
          style: TextStyle(
            color: Colors.amber,
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 12),
        Text(
          anime['year']!,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 12),
        Text(
          anime['genre']!,
          style: TextStyle(
            color: Colors.white60,
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimeTitle(Map<String, String> anime, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;

    return Text(
      anime['title']!,
      style: TextStyle(
        fontSize: isDesktop ? 56 : (isTablet ? 40 : 32),
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: -0.5,
        height: 1.1,
        shadows: [
          Shadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.8),
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeSubtitle(Map<String, String> anime, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;

    return Text(
      anime['subtitle']!,
      style: TextStyle(
        fontSize: isDesktop ? 24 : (isTablet ? 20 : 18),
        color: Color(0xFFE50914),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildAnimeDescription(Map<String, String> anime, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;

    return Container(
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 600 : (isTablet ? 500 : double.infinity),
      ),
      child: Text(
        anime['description']!,
        style: TextStyle(
          fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.2,
        ),
        maxLines: isDesktop ? 3 : 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButtons(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;

    return Row(
      children: [
        _buildPrimaryButton(
          icon: Icons.play_arrow,
          label: 'Watch Now',
          onPressed: () {},
          constraints: constraints,
        ),
        SizedBox(width: isDesktop ? 16 : 12),
        _buildSecondaryButton(
          icon: Icons.add,
          label: 'My List',
          onPressed: () {},
          constraints: constraints,
        ),
        SizedBox(width: isDesktop ? 16 : 12),
        _buildIconButton(
          icon: Icons.thumb_up_outlined,
          onPressed: () {},
          constraints: constraints,
        ),
        SizedBox(width: 8),
        _buildIconButton(
          icon: Icons.share_outlined,
          onPressed: () {},
          constraints: constraints,
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required BoxConstraints constraints,
  }) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: isDesktop ? 24 : 20),
      label: Text(
        label,
        style: TextStyle(
          fontSize: isDesktop ? 16 : 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE50914),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : (isTablet ? 24 : 20),
          vertical: isDesktop ? 16 : 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 8,
        shadowColor: Color(0xFFE50914).withOpacity(0.3),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required BoxConstraints constraints,
  }) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: isDesktop ? 24 : 20),
      label: Text(
        label,
        style: TextStyle(
          fontSize: isDesktop ? 16 : 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withOpacity(0.7), width: 2),
        backgroundColor: Colors.black.withOpacity(0.4),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32 : (isTablet ? 24 : 20),
          vertical: isDesktop ? 16 : 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required BoxConstraints constraints,
  }) {
    final isDesktop = constraints.maxWidth > 1200;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        iconSize: isDesktop ? 24 : 20,
        padding: EdgeInsets.all(isDesktop ? 12 : 10),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Positioned.fill(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavButton(Icons.chevron_left, () => _carouselController.previousPage()),
          _buildNavButton(Icons.chevron_right, () => _carouselController.nextPage()),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white, size: 32),
          padding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCarouselIndicators(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;

    return Positioned(
      bottom: 20,
      right: isDesktop ? 80 : (isTablet ? 40 : 24),
      child: Row(
        children: List.generate(
          _heroAnimes.length,
              (index) => GestureDetector(
            onTap: () => _carouselController.animateToPage(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 32 : 12,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _currentIndex == index
                    ? Color(0xFFE50914)
                    : Colors.white.withOpacity(0.4),
                boxShadow: _currentIndex == index
                    ? [BoxShadow(
                  color: Color(0xFFE50914).withOpacity(0.5),
                  blurRadius: 8,
                )]
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1200;
          final isTablet = constraints.maxWidth > 768;

          return Container(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 80 : (isTablet ? 40 : 24),
              60,
              isDesktop ? 80 : (isTablet ? 40 : 24),
              40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Trending Now', '🔥', constraints),
                SizedBox(height: 24),
                SizedBox(
                  height: isDesktop ? 320 : (isTablet ? 280 : 240),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _trendingAnimes.length,
                    itemBuilder: (context, index) => _buildAnimeCard(
                      _trendingAnimes[index],
                      constraints,
                      index,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1200;
          final isTablet = constraints.maxWidth > 768;

          return Container(
            padding: EdgeInsets.fromLTRB(
              isDesktop ? 80 : (isTablet ? 40 : 24),
              40,
              isDesktop ? 80 : (isTablet ? 40 : 24),
              40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Recommended for You', '✨', constraints),
                SizedBox(height: 24),
                SizedBox(
                  height: isDesktop ? 320 : (isTablet ? 280 : 240),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _trendingAnimes.length,
                    itemBuilder: (context, index) => _buildAnimeCard(
                      _trendingAnimes[(_trendingAnimes.length - 1) - index],
                      constraints,
                      index,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, String emoji, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;

    return Row(
      children: [
        Text(
          emoji,
          style: TextStyle(fontSize: isDesktop ? 32 : 24),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: isDesktop ? 32 : (isTablet ? 24 : 22),
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'View All',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: isDesktop ? 16 : 14,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnimeCard(Map<String, String> anime, BoxConstraints constraints, int index) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;
    final cardWidth = isDesktop ? 200.0 : (isTablet ? 160.0 : 140.0);

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(right: isDesktop ? 20 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: anime['image']!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildCardPlaceholder(constraints),
                      errorWidget: (context, url, error) => _buildCardError(constraints),
                    ),
                    _buildCardOverlay(),
                    _buildCardRating(anime['rating']!, constraints),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            anime['title']!,
            style: TextStyle(
              color: Colors.white,
              fontSize: isDesktop ? 16 : 14,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCardPlaceholder(BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A1F), Color(0xFF2A2A2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(Color(0xFFE50914)),
        ),
      ),
    );
  }

  Widget _buildCardError(BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1A1F), Color(0xFF2A2A2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.error_outline,
          color: Color(0xFFE50914),
          size: 32,
        ),
      ),
    );
  }

  Widget _buildCardOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildCardRating(String rating, BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;

    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.amber.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star,
              color: Colors.amber,
              size: isDesktop ? 14 : 12,
            ),
            SizedBox(width: 4),
            Text(
              rating,
              style: TextStyle(
                color: Colors.white,
                fontSize: isDesktop ? 12 : 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D0D0F),
                  Color(0xFF1A1A1F),
                ],
              ),
            ),
            child: Column(
              children: [
                _buildNewsletterSection(constraints),
                SizedBox(height: 60),
                _buildFooterContent(constraints),
                SizedBox(height: 40),
                _buildFooterBottom(constraints),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsletterSection(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;
    final isTablet = constraints.maxWidth > 768;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 40 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE50914).withOpacity(0.1),
            Color(0xFFE50914).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE50914).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            '📺 Stay Updated',
            style: TextStyle(
              fontSize: isDesktop ? 28 : 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Get notified about new episodes and trending anime',
            style: TextStyle(
              fontSize: isDesktop ? 16 : 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          if (isDesktop)
            _buildDesktopNewsletterForm()
          else
            _buildMobileNewsletterForm(),
        ],
      ),
    );
  }

  Widget _buildDesktopNewsletterForm() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 300,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: Colors.white60),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white30),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFE50914)),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {},
          child: Text('Subscribe'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE50914),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileNewsletterForm() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyle(color: Colors.white60),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white30),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE50914)),
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Subscribe'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE50914),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterContent(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildFooterBrand()),
          SizedBox(width: 60),
          Expanded(child: _buildFooterLinks('Browse', ['Popular', 'New Releases', 'Top Rated', 'Genres'])),
          Expanded(child: _buildFooterLinks('Support', ['Help Center', 'Contact Us', 'Report Issue', 'Feedback'])),
          Expanded(child: _buildFooterLinks('Legal', ['Privacy Policy', 'Terms of Service', 'Cookie Policy', 'DMCA'])),
        ],
      );
    } else {
      return Column(
        children: [
          _buildFooterBrand(),
          SizedBox(height: 40),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildFooterLinks('Browse', ['Popular', 'New Releases', 'Top Rated'])),
              Expanded(child: _buildFooterLinks('Support', ['Help Center', 'Contact Us', 'Feedback'])),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildFooterBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFE50914),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.play_arrow, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Text(
              'AnimeStream',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Your ultimate destination for streaming\nthe best anime content.',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            _buildSocialButton(Icons.facebook),
            SizedBox(width: 12),
            _buildSocialButton(Icons.alternate_email),
            SizedBox(width: 12),
            _buildSocialButton(Icons.discord),
            SizedBox(width: 12),
            _buildSocialButton(Icons.telegram),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }

  Widget _buildFooterLinks(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16),
        ...links.map((link) => Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            link,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildFooterBottom(BoxConstraints constraints) {
    final isDesktop = constraints.maxWidth > 1200;

    return Container(
      padding: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: isDesktop
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© 2024 AnimeStream. All rights reserved.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          Text(
            'Made with ❤️ for anime fans',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      )
          : Column(
        children: [
          Text(
            '© 2024 AnimeStream. All rights reserved.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Made with ❤️ for anime fans',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}