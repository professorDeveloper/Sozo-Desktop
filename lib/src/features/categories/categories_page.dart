import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_color.dart';
import '../../core/constants/app_style.dart';

// Model Classes
class AnimeGenre {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int animeCount;

  AnimeGenre({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.animeCount,
  });
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Genre list from backend (this would come from your API)
  final List<AnimeGenre> _genres = [
    AnimeGenre(
      id: '1',
      name: 'Action',
      description: 'High-energy battles and thrilling adventures',
      icon: Icons.flash_on,
      color: Colors.red,
      animeCount: 245,
    ),
    AnimeGenre(
      id: '2',
      name: 'Adventure',
      description: 'Epic journeys and exciting quests',
      icon: Icons.explore,
      color: Colors.orange,
      animeCount: 189,
    ),
    AnimeGenre(
      id: '3',
      name: 'Comedy',
      description: 'Laugh-out-loud moments and humor',
      icon: Icons.sentiment_very_satisfied,
      color: Colors.amber,
      animeCount: 167,
    ),
    AnimeGenre(
      id: '4',
      name: 'Drama',
      description: 'Emotional stories and character development',
      icon: Icons.theater_comedy,
      color: Colors.blue,
      animeCount: 203,
    ),
    AnimeGenre(
      id: '5',
      name: 'Fantasy',
      description: 'Magical worlds and supernatural elements',
      icon: Icons.auto_awesome,
      color: Colors.purple,
      animeCount: 198,
    ),
    AnimeGenre(
      id: '6',
      name: 'Romance',
      description: 'Love stories and relationships',
      icon: Icons.favorite,
      color: Colors.pink,
      animeCount: 156,
    ),
    AnimeGenre(
      id: '7',
      name: 'Sci-Fi',
      description: 'Futuristic technology and space adventures',
      icon: Icons.rocket_launch,
      color: Colors.cyan,
      animeCount: 134,
    ),
    AnimeGenre(
      id: '8',
      name: 'Thriller',
      description: 'Suspenseful plots and mysteries',
      icon: Icons.psychology,
      color: Colors.deepPurple,
      animeCount: 112,
    ),
    AnimeGenre(
      id: '9',
      name: 'Horror',
      description: 'Dark and spine-chilling stories',
      icon: Icons.dark_mode,
      color: Colors.grey[800]!,
      animeCount: 89,
    ),
    AnimeGenre(
      id: '10',
      name: 'Sports',
      description: 'Athletic competitions and teamwork',
      icon: Icons.sports_soccer,
      color: Colors.green,
      animeCount: 98,
    ),
    AnimeGenre(
      id: '11',
      name: 'Slice of Life',
      description: 'Everyday moments and realistic stories',
      icon: Icons.home,
      color: Colors.teal,
      animeCount: 145,
    ),
    AnimeGenre(
      id: '12',
      name: 'Supernatural',
      description: 'Ghosts, demons, and paranormal events',
      icon: Icons.visibility_off,
      color: Colors.indigo,
      animeCount: 176,
    ),
    AnimeGenre(
      id: '13',
      name: 'Mecha',
      description: 'Giant robots and mechanical warfare',
      icon: Icons.precision_manufacturing,
      color: Colors.blueGrey,
      animeCount: 87,
    ),
    AnimeGenre(
      id: '14',
      name: 'Historical',
      description: 'Set in historical periods and events',
      icon: Icons.history_edu,
      color: Colors.brown,
      animeCount: 76,
    ),
    AnimeGenre(
      id: '15',
      name: 'Music',
      description: 'Musical performances and rhythm',
      icon: Icons.music_note,
      color: Colors.deepOrange,
      animeCount: 54,
    ),
    AnimeGenre(
      id: '16',
      name: 'School',
      description: 'Student life and academic adventures',
      icon: Icons.school,
      color: Colors.lightBlue,
      animeCount: 234,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
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
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  List<AnimeGenre> get _filteredGenres {
    if (_searchQuery.isEmpty) {
      return _genres;
    }

    return _genres
        .where((genre) =>
    genre.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        genre.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildResultsHeader(),
                const SizedBox(height: 20),
                _buildGenresGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColors.Red, Colors.purpleAccent],
              ).createShader(bounds),
              child: Text(
                'Anime Genres',
                style: GoogleFonts.daysOne(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore anime by genre',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Search Bar
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.9 + (value * 0.1),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            width: 320,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0x15FFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0x20FFFFFF),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.Red.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search genres...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white.withOpacity(0.5),
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsHeader() {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            '${_filteredGenres.length} genres',
            key: ValueKey(_filteredGenres.length),
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 4,
          width: 4,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Browse all categories',
          style: TextStyle(
            color: AppColors.Red,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGenresGrid() {
    if (_filteredGenres.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category_outlined,
                size: 64,
                color: Colors.white.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              Text(
                'No genres found',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.4,
        ),
        itemCount: _filteredGenres.length,
        itemBuilder: (context, index) {
          return _AnimatedGenreCard(
            genre: _filteredGenres[index],
            index: index,
          );
        },
      ),
    );
  }
}

// Animated Genre Card Widget
class _AnimatedGenreCard extends StatefulWidget {
  final AnimeGenre genre;
  final int index;

  const _AnimatedGenreCard({
    required this.genre,
    required this.index,
  });

  @override
  State<_AnimatedGenreCard> createState() => _AnimatedGenreCardState();
}

class _AnimatedGenreCardState extends State<_AnimatedGenreCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (widget.index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _scaleController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _scaleController.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: () {
              // Navigate to genre anime list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${widget.genre.name} anime'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: widget.genre.color,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? widget.genre.color.withOpacity(0.4)
                        : Colors.black.withOpacity(0.3),
                    blurRadius: _isHovered ? 24 : 12,
                    offset: Offset(0, _isHovered ? 12 : 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF2A2A2A),
                        const Color(0xFF1A1A1A),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background Pattern
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          widget.genre.icon,
                          size: 120,
                          color: widget.genre.color.withOpacity(0.1),
                        ),
                      ),

                      // Gradient Overlay
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.genre.color.withOpacity(_isHovered ? 0.3 : 0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: widget.genre.color.withOpacity(_isHovered ? 0.3 : 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: widget.genre.color.withOpacity(0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                widget.genre.icon,
                                color: widget.genre.color,
                                size: 28,
                              ),
                            ),
                            const Spacer(),

                            // Genre Name
                            Text(
                              widget.genre.name,
                              style: GoogleFonts.daysOne(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Description
                            Text(
                              widget.genre.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),

                            // Anime Count
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white.withOpacity(0.9),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${widget.genre.animeCount} anime',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                AnimatedRotation(
                                  duration: const Duration(milliseconds: 200),
                                  turns: _isHovered ? 0.125 : 0,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: widget.genre.color,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}