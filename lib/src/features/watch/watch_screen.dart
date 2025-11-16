// lib/screens/watch_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../parser/anime_paphe.dart';
import 'dart:ui';

import 'custom_player.dart';

class WatchScreen extends StatefulWidget {
  final String animeTitle;
  final String episodeTitle;
  final String session;
  final String animeSession;

  const WatchScreen({
    super.key,
    required this.animeTitle,
    required this.episodeTitle,
    required this.session,
    required this.animeSession,
  });

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen>
    with SingleTickerProviderStateMixin {
  String? _url;
  bool _loading = true;
  String? _error;
  List<dynamic> _availableQualities = [];
  double _loadingProgress = 0.0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize pulse animation for loading
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _loadUrl();
  }

  Future<void> _loadUrl() async {
    setState(() {
      _loading = true;
      _error = null;
      _loadingProgress = 0.0;
    });

    try {
      final parser = AnimePahe();

      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _loadingProgress = 0.2);

      final options = await parser.getEpisodeVideo(
        widget.session,
        widget.animeSession,
      );

      if (options.isEmpty) {
        throw Exception('No video sources available');
      }

      setState(() {
        _availableQualities = options;
        _loadingProgress = 0.5;
      });

      await Future.delayed(const Duration(milliseconds: 200));

      final best = options.firstWhere(
            (o) => o.resolution == '1080p',
        orElse: () => options.firstWhere(
              (o) => o.resolution == '720p',
          orElse: () => options.first,
        ),
      );

      setState(() => _loadingProgress = 0.7);

      final url = await parser.extractVideo(best.kwikUrl);

      if (url.isEmpty) {
        throw Exception('Failed to extract video URL');
      }

      setState(() => _loadingProgress = 0.9);

      await Future.delayed(const Duration(milliseconds: 300));

      setState(() {
        _url = url;
        _loading = false;
        _loadingProgress = 1.0;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
        _loadingProgress = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return _buildNetflixLoadingState();
    }

    if (_error != null) {
      return _buildNetflixErrorState();
    }

    if (_url != null) {
      return CustomVideoPlayer(
        url: _url!,
        title: '${widget.animeTitle} • ${widget.episodeTitle}',
      );
    }

    return const SizedBox();
  }

  Widget _buildNetflixLoadingState() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background gradient
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [
                const Color(0xFF1a1a1a),
                Colors.black,
              ],
            ),
          ),
        ),

        // Animated circles in background
        ...List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Center(
                child: Container(
                  width: 150.0 + (index * 100) * _pulseAnimation.value,
                  height: 150.0 + (index * 100) * _pulseAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE50914).withOpacity(
                        0.1 - (index * 0.03),
                      ),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Netflix-style loading logo
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE50914),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE50914).withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Progress text
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: _loadingProgress),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Column(
                    children: [
                      Text(
                        '${(value * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: value,
                            backgroundColor: Colors.white.withOpacity(0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFE50914),
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Loading message
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _getLoadingMessage(),
                  key: ValueKey(_getLoadingMessage()),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Anime info
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.animeTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.episodeTitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_availableQualities.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: _availableQualities.take(4).map((q) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE50914).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE50914),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              q.resolution ?? 'HD',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // Back button
        SafeArea(
          child: Positioned(
            top: 16,
            left: 16,
            child: Material(
              color: Colors.black.withOpacity(0.5),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                customBorder: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getLoadingMessage() {
    if (_loadingProgress < 0.3) {
      return 'Connecting to server...';
    } else if (_loadingProgress < 0.6) {
      return 'Finding best quality...';
    } else if (_loadingProgress < 0.8) {
      return 'Preparing stream...';
    } else {
      return 'Almost ready...';
    }
  }

  Widget _buildNetflixErrorState() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                const Color(0xFF2a0a0a),
                Colors.black,
              ],
            ),
          ),
        ),

        // Content
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon with animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE50914).withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE50914),
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.error_outline_rounded,
                          size: 60,
                          color: Color(0xFFE50914),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Error title
                const Text(
                  'Oops!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                // Error description
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    _getErrorDescription(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 15,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // Action buttons
                Column(
                  children: [
                    // Retry button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _loadUrl,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_rounded, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Try Again',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Go back button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_rounded, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Go Back',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Help section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.help_outline_rounded,
                            color: Colors.white.withOpacity(0.6),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Common Solutions',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...const [
                        '• Check your internet connection',
                        '• Try a different network (WiFi/Mobile data)',
                        '• Wait a few minutes and try again',
                        '• The video source may be temporarily unavailable',
                      ].map((tip) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          tip,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),

                // Technical details (collapsible)
                const SizedBox(height: 20),
                Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      'View Technical Details',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    iconColor: Colors.white.withOpacity(0.5),
                    collapsedIconColor: Colors.white.withOpacity(0.5),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SelectableText(
                          _error ?? 'Unknown error',
                          style: TextStyle(
                            color: const Color(0xFFE50914).withOpacity(0.8),
                            fontSize: 11,
                            fontFamily: 'monospace',
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Back button
        SafeArea(
          child: Positioned(
            top: 16,
            left: 16,
            child: Material(
              color: Colors.black.withOpacity(0.5),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                customBorder: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getErrorDescription() {
    if (_error!.toLowerCase().contains('connection')) {
      return 'We couldn\'t connect to the video server. Please check your internet connection and try again.';
    } else if (_error!.toLowerCase().contains('timeout')) {
      return 'The request is taking too long. The server might be busy or your connection is slow.';
    } else if (_error!.contains('No video sources')) {
      return 'No video sources are available for this episode right now. Please try again later.';
    } else {
      return 'We encountered an unexpected error while loading your video. Don\'t worry, this usually fixes itself.';
    }
  }
}