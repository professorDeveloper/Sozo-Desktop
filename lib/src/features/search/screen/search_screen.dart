import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import '../../../core/constants/app_color.dart';
import '../../home/model/home_anime_model.dart';
import '../bloc/search_bloc.dart';
import 'dart:ui';
import 'dart:async';

import '../bloc/search_event.dart' hide SearchLoading, SearchState, SearchEmpty, SearchLoaded, SearchInitial, SearchError;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  Timer? _placeholderTimer;
  late AnimationController _placeholderController;
  late Animation<double> _placeholderAnimation;

  bool _isSearchActive = false;
  final List<String> _recentSearches = ['One Piece', 'Naruto', 'Attack on Titan','Death Note','Demon Slayer','Jujutsu Kaisen','Chain','Bleach','Tokyo Revengers','My Hero Academia'];

  final List<String> _placeholders = [
    'One Piece..',
    'Naruto..',
    'Demon Slayer..',
    'Attack on Titan..',
    'Jujutsu Kaisen..',
  ];
  int _currentPlaceholderIndex = 0;
  String _currentPlaceholder = 'One Piece..';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isSearchActive = _focusNode.hasFocus;
      });
    });

    _placeholderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _placeholderAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _placeholderController, curve: Curves.easeInOut),
    );

    _startPlaceholderRotation();
  }

  void _startPlaceholderRotation() {
    _placeholderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_searchController.text.isEmpty && !_isSearchActive) {
        _placeholderController.forward().then((_) {
          if (mounted) {
            setState(() {
              _currentPlaceholderIndex =
                  (_currentPlaceholderIndex + 1) % _placeholders.length;
              _currentPlaceholder = _placeholders[_currentPlaceholderIndex];
            });
            _placeholderController.reverse();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    _placeholderTimer?.cancel();
    _placeholderController.dispose();
    _debounce?.cancel(); // ✅ Timer to‘xtatish
    context.read().close(); // ✅ Bloc to‘xtatish
    super.dispose();
  }


  void _performSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return; // <-- sahifa o‘chirilgan bo‘lsa, qaytadi
      if (mounted) {
        context.read<SearchBloc>().add(PerformSearch(query));
      }

      final bloc = context.read<SearchBloc>();
      if (!bloc.isClosed) { // <-- Bloc hali ochiqmi, tekshirish
        bloc.add(PerformSearch(query));
      }
    });
  }


  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(ClearSearch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            opacity: _searchController.text.isEmpty ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _searchController.text.isEmpty ? null : 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Search',
                  style: GoogleFonts.daysOne(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 56,
            decoration: ShapeDecoration(
              color: Colors.white.withOpacity(_isSearchActive ? 0.12 : 0.08),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: _isSearchActive ? 2 : 1,
                  color: _isSearchActive
                      ? Colors.white.withOpacity(0.60)
                      : Colors.white.withOpacity(0.35),
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              shadows: _isSearchActive
                  ? [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ]
                  : null,
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Colors.white,
              cursorWidth: 2,
              cursorHeight: 20,
              decoration: InputDecoration(
                hintText: _currentPlaceholder,
                hintStyle: GoogleFonts.rubik(
                  color: Colors.white.withOpacity(_placeholderAnimation.value * 0.40),
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                prefixIcon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.search_rounded,
                    color: _isSearchActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    size: _isSearchActive ? 26 : 24,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                    onPressed: _clearSearch,
                    splashRadius: 20,
                    splashColor: Colors.white.withOpacity(0.1),
                  ),
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onChanged: _performSearch,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        if (state is SearchError) {
          return _buildErrorState(state.message);
        }

        if (state is SearchEmpty || state is SearchInitial) {
          return _buildEmptyState();
        }

        if (state is SearchLoaded) {
          if (state.results.isEmpty) {
            return _buildNoResults();
          }
          return _buildSearchResults(state.results);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              style: GoogleFonts.rubik(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _performSearch(_searchController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.rubik(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Icon(
              Icons.search,
              size: 64,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'Start typing to search',
              style: GoogleFonts.rubik(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
            if (_recentSearches.isNotEmpty) ...[
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Searches',
                  style: GoogleFonts.rubik(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _recentSearches.map((search) {
                  return InkWell(
                    onTap: () {
                      _searchController.text = search;
                      _performSearch(search);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            size: 14,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            search,
                            style: GoogleFonts.rubik(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: GoogleFonts.daysOne(
              color: Colors.white.withOpacity(0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords',
            style: GoogleFonts.rubik(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<HomeAnimeModel> results) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 160,
          childAspectRatio: 0.55,
          crossAxisSpacing: 22,
          mainAxisSpacing: 20,
        ),
        itemCount: results.length,
        itemBuilder: (context, index) {
          return _SearchAnimeItem(item: results[index]);
        },
      ),
    );
  }
}

class _SearchAnimeItem extends StatefulWidget {
  final HomeAnimeModel item;

  const _SearchAnimeItem({required this.item});

  @override
  State<_SearchAnimeItem> createState() => _SearchAnimeItemState();
}

class _SearchAnimeItemState extends State<_SearchAnimeItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          // Navigate to detail screen
          // Navigator.push(context, MaterialPageRoute(...));
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
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.item.coverImage?.large ??
                            'https://via.placeholder.com/300x450.png?text=No+Cover',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.white.withOpacity(0.1),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.white.withOpacity(0.1),
                          child: const Icon(Icons.error, color: Colors.white),
                        ),
                      ),
                      if (isHovered)
                        Container(
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
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 7),
              SizedBox(
                height: 20,
                child: (widget.item.title?.english?.length ?? 0) > 15
                    ? Marquee(
                  text: widget.item.title?.english ?? 'Unknown',
                  style: GoogleFonts.daysOne(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                  ),
                  scrollAxis: Axis.horizontal,
                  blankSpace: 40.0,
                  velocity: 30.0,
                  pauseAfterRound: const Duration(seconds: 1),
                  startPadding: 0.0,
                )
                    : Text(
                  widget.item.title?.english ?? 'Unknown',
                  style: GoogleFonts.daysOne(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isHovered ? FontWeight.bold : FontWeight.normal,
                  ),
                  maxLines: 1,
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
                    widget.item.seasonYear?.toString() ?? 'N/A',
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
                      widget.item.format ?? 'TV',
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