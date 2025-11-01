import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';

import '../../core/constants/app_color.dart';
import '../home/model/home_anime_model.dart';
import 'bloc/categories_bloc.dart';
import 'bloc/categories_event.dart';
import 'bloc/categories_state.dart';
import 'genre_image_service.dart';

class BrowseAnimePage extends StatefulWidget {
  const BrowseAnimePage({super.key});

  @override
  State<BrowseAnimePage> createState() => _BrowseAnimePageState();
}

class _BrowseAnimePageState extends State<BrowseAnimePage>
    with SingleTickerProviderStateMixin {
  final Map<String, String?> _prefetchedGenreImages = {};
  late TabController _tabController;
  final ScrollController _animeScrollController = ScrollController();
  final ScrollController _genreAnimeScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load initial data
    context.read<CategoriesBloc>().add(LoadAllAnime());

    // Setup scroll listeners for infinite scrolling
    _animeScrollController.addListener(_onAnimeScroll);
    _genreAnimeScrollController.addListener(_onGenreAnimeScroll);

    // Load genres when switching to genres tab
    _tabController.addListener(() {
      if (!mounted) return;

      final currentState = context.read<CategoriesBloc>().state;

      if (_tabController.index == 1) {
        // Switching to Genres tab
        if (currentState is! CategoriesGenresLoaded &&
            currentState is! CategoriesGenreAnimeLoaded &&
            currentState is! CategoriesGenreAnimeLoading) {
          context.read<CategoriesBloc>().add(LoadGenres());
        }
      } else if (_tabController.index == 0) {
        // Switching to All Anime tab
        if (currentState is! CategoriesAnimeLoaded &&
            currentState is! CategoriesLoading) {
          context.read<CategoriesBloc>().add(LoadAllAnime());
        }
      }
    });
  }

  void _onAnimeScroll() {
    if (_animeScrollController.position.pixels >=
        _animeScrollController.position.maxScrollExtent * 0.9) {
      context.read<CategoriesBloc>().add(LoadMoreAnime());
    }
  }

  void _onGenreAnimeScroll() {
    if (_genreAnimeScrollController.position.pixels >=
        _genreAnimeScrollController.position.maxScrollExtent * 0.9) {
      context.read<CategoriesBloc>().add(LoadMoreGenreAnime());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animeScrollController.dispose();
    _genreAnimeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 16),
      child: Row(
        children: [
          Text(
            'Browse Anime',
            style: GoogleFonts.daysOne(color: Colors.white, fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(50),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        labelStyle: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'All Anime'),
          Tab(text: 'Genres'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [_buildAllAnimeTab(), _buildGenresTab()],
    );
  }

  Widget _buildAllAnimeTab() {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesInitial) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        if (state is CategoriesLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        if (state is CategoriesError) {
          // Only show error if it's relevant to this tab
          if (state.message.contains('anime') ||
              state.message.contains('fetch')) {
            return _buildErrorState(state.message, genre: state.genre);
          }
          // Otherwise, reload data
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<CategoriesBloc>().add(LoadAllAnime());
          });
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        if (state is CategoriesAnimeLoaded) {
          return _buildAnimeGrid(
            animeList: state.animeList,
            scrollController: _animeScrollController,
            isLoadingMore: state.isLoadingMore,
          );
        }

        // If in genre-related states, reload all anime data
        if (state is CategoriesGenresLoaded ||
            state is CategoriesGenreAnimeLoading ||
            state is CategoriesGenreAnimeLoaded) {
          // Trigger reload when coming back to this tab
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_tabController.index == 0) {
              context.read<CategoriesBloc>().add(LoadAllAnime());
            }
          });
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGenresTab() {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        // Handle initial or loading state
        if (state is CategoriesInitial || state is CategoriesLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        if (state is CategoriesGenresLoaded) {
          return _buildGenresList(state.genres);
        }

        if (state is CategoriesGenreAnimeLoading) {
          return _buildGenreLoadingState(state.genre);
        }

        if (state is CategoriesGenreAnimeLoaded) {
          return _buildGenreAnimeView(state);
        }

        if (state is CategoriesError) {
          return _buildErrorState(state.message, genre: state.genre);
        }

        // If in anime-related states, reload genres
        if (state is CategoriesAnimeLoaded) {
          // Trigger reload when switching to this tab
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_tabController.index == 1) {
              context.read<CategoriesBloc>().add(LoadGenres());
            }
          });
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGenresList(List<String> genres) {
    if (_prefetchedGenreImages.isEmpty) {
      print('Starting image prefetch for ${genres.length} genres');
      GenreImageService.prefetchGenres(genres)
          .then((map) {
            if (!mounted) return;
            print(
              'Prefetch complete. Got ${map.entries.where((e) => e.value != null).length} images',
            );
            setState(() {
              _prefetchedGenreImages.clear();
              _prefetchedGenreImages.addAll(map);
            });
          })
          .catchError((error) {
            print('Error prefetching genre images: $error');
          });
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(25),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2.5,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          final selectedImage = _prefetchedGenreImages[genre];
          return _GenreCard(
            genre: genre,
            selectedImage: selectedImage,
            onTap: () {
              context.read<CategoriesBloc>().add(LoadGenreAnime(genre: genre));
            },
          );
        },
      ),
    );
  }

  Widget _buildGenreLoadingState(String genre) {
    return Column(
      children: [
        _buildGenreHeader(
          genre,
          onBack: () {
            context.read<CategoriesBloc>().add(LoadGenres());
          },
        ),
        const Expanded(
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenreAnimeView(CategoriesGenreAnimeLoaded state) {
    return Column(
      children: [
        _buildGenreHeader(
          state.genre,
          onBack: () {
            context.read<CategoriesBloc>().add(LoadGenres());
          },
        ),
        Expanded(
          child: _buildAnimeGrid(
            animeList: state.animeList,
            scrollController: _genreAnimeScrollController,
            isLoadingMore: state.isLoadingMore,
          ),
        ),
      ],
    );
  }

  Widget _buildGenreHeader(String genre, {required VoidCallback onBack}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 10),
          Text(
            genre,
            style: GoogleFonts.daysOne(color: Colors.white, fontSize: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeGrid({
    required List<HomeAnimeModel> animeList,
    required ScrollController scrollController,
    required bool isLoadingMore,
  }) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 160,
                childAspectRatio: 0.55,
                crossAxisSpacing: 23,
                mainAxisSpacing: 20,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return _AnimeCard(anime: animeList[index]);
              }, childCount: animeList.length),
            ),
          ),
          if (isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, {String? genre}) {
    final isTimeout =
        message.toLowerCase().contains('timeout') ||
        message.toLowerCase().contains('timed out');
    final isNetwork =
        message.toLowerCase().contains('network') ||
        message.toLowerCase().contains('internet');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isTimeout
                ? Icons.access_time
                : isNetwork
                ? Icons.wifi_off
                : Icons.error_outline,
            size: 64,
            color: isTimeout
                ? Colors.orange.withOpacity(0.6)
                : isNetwork
                ? Colors.blue.withOpacity(0.6)
                : Colors.red.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              style: GoogleFonts.rubik(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (genre != null)
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<CategoriesBloc>().add(LoadGenres());
                  },
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: Text(
                    'Back to Genres',
                    style: GoogleFonts.rubik(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              if (genre != null) const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  if (genre != null) {
                    context.read<CategoriesBloc>().add(
                      LoadGenreAnime(genre: genre),
                    );
                  } else {
                    context.read<CategoriesBloc>().add(LoadAllAnime());
                  }
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: Text('Retry', style: GoogleFonts.rubik(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Genre Card Widget
class _GenreCard extends StatefulWidget {
  final String genre;
  final VoidCallback onTap;
  final String? selectedImage;

  const _GenreCard({
    required this.genre,
    required this.onTap,
    this.selectedImage,
  });

  @override
  State<_GenreCard> createState() => _GenreCardState();
}

class _GenreCardState extends State<_GenreCard> {
  bool isHovered = false;

  // Map of genre to background image URLs
  final Map<String, String> _genreImages = {
    'Action': '', // Attack on Titan
    'Adventure': '', // One Piece
    'Comedy': '', // Gintama
    'Drama': '', // Your Lie in April
    'Fantasy': '', // Made in Abyss
    'Horror': '', // Tokyo Ghoul
    'Mystery': '', // Death Note
    'Romance': '', // Your Name
    'Sci-Fi': '', // Steins;Gate
    'Slice of Life': '', // K-On!
    'Sports': '',
    'Supernatural': '',
    'Thriller': 'https://i.imgur.com/bvmq0SN.jpg', // Monster
  };

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isHovered
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Builder(
                    builder: (context) {
                      final imageUrl =
                          widget.selectedImage ?? _genreImages[widget.genre];

                      if (imageUrl == null || imageUrl.isEmpty) {
                        print('No image URL for genre: ${widget.genre}');
                        return Image.asset(
                          'assets/images/img.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Failed to load fallback image: $error');
                            return Container(
                              color: Colors.grey.withOpacity(0.2),
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 24,
                                ),
                              ),
                            );
                          },
                        );
                      }

                      return CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 300),
                        placeholder: (context, url) => Container(
                          color: Colors.white.withOpacity(0.08),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.3),
                              ),
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          print(
                            'Failed to load image for ${widget.genre}: $error',
                          );
                          return Image.asset(
                            'assets/images/img.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.withOpacity(0.2),
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white.withOpacity(0.5),
                                    size: 24,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                // Dark Overlay
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isHovered
                          ? Colors.black.withOpacity(0.5)
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
                // Text
                Center(
                  child: Text(
                    widget.genre,
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: isHovered ? FontWeight.w600 : FontWeight.w400,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Anime Card Widget
class _AnimeCard extends StatefulWidget {
  final HomeAnimeModel anime;

  const _AnimeCard({required this.anime});

  @override
  State<_AnimeCard> createState() => _AnimeCardState();
}

class _AnimeCardState extends State<_AnimeCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          // Navigate to detail screen
          // Navigator.pushNamed(context, '/detail', arguments: widget.anime.id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(isHovered ? 1.05 : 1.0)
            ..translate(0.0, isHovered ? -5.0 : 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
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
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl:
                        widget.anime.coverImage?.large ??
                        'https://via.placeholder.com/300x450.png?text=No+Cover',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.white.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.white.withOpacity(0.1),
                      child: const Icon(Icons.error, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              SizedBox(
                height: 20,
                child: (widget.anime.title?.english?.length ?? 0) > 15
                    ? Marquee(
                        text: widget.anime.title?.english ?? 'Unknown',
                        style: GoogleFonts.daysOne(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        scrollAxis: Axis.horizontal,
                        blankSpace: 40.0,
                        velocity: 30.0,
                        pauseAfterRound: const Duration(seconds: 1),
                        startPadding: 0.0,
                      )
                    : Text(
                        widget.anime.title?.english ?? 'Unknown',
                        style: GoogleFonts.daysOne(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
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
                    widget.anime.seasonYear?.toString() ?? 'N/A',
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
                  Flexible(
                    child: Text(
                      widget.anime.format ?? 'TV',
                      style: GoogleFonts.rubik(
                        color: isHovered ? Colors.white : Colors.white70,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
