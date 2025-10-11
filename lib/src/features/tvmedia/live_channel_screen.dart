import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sozodesktop/src/utils/itv_garden_manager.dart';
import 'package:pod_player/pod_player.dart';

class LiveChannelScreen extends StatefulWidget {
  final Channel channel;

  const LiveChannelScreen({required this.channel, super.key});

  @override
  State<LiveChannelScreen> createState() => _LiveChannelScreenState();
}

class _LiveChannelScreenState extends State<LiveChannelScreen> {
  PodPlayerController? _podController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // Validate URLs availability
      if (widget.channel.iptvUrls.isEmpty) {
        setState(() {
          _errorMessage = 'No video URLs available for this channel';
          _isLoading = false;
        });
        return;
      }

      final url = widget.channel.iptvUrls[0];

      // Check for YouTube URLs
      if (_isYouTubeUrl(url)) {
        setState(() {
          _errorMessage = 'YouTube videos are not supported in this player';
          _isLoading = false;
        });
        return;
      }

      // Validate URL format
      if (!_isValidUrl(url)) {
        setState(() {
          _errorMessage = 'Invalid video URL format';
          _isLoading = false;
        });
        return;
      }

      // Initialize the player
      _podController = PodPlayerController(
        playVideoFrom: PlayVideoFrom.network(url),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: true,
          isLooping: false,
          forcedVideoFocus: true,
        ),
      );

      await _podController!.initialise();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load video: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  bool _isYouTubeUrl(String url) {
    return url.contains('youtube.com') ||
        url.contains('youtu.be') ||
        url.contains('youtube-nocookie.com');
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  Future<void> _retryLoading() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await _initializePlayer();
  }

  @override
  void dispose() {
    _podController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.channel.name.toString(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          if (_errorMessage != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _retryLoading,
              tooltip: 'Retry',
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Loading video...',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _retryLoading,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_podController == null) {
      return const Center(
        child: Text(
          'Player not initialized',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: PodVideoPlayer(controller: _podController!),
      ),
    );
  }
}