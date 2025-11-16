// lib/widgets/custom_video_player.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class CustomVideoPlayer extends StatefulWidget {
  final String url;
  final String title;

  const CustomVideoPlayer({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isBuffering = false;
  double _volume = 1.0;
  double _playbackSpeed = 1.0;
  String _position = '0:00';
  String _duration = '0:00';
  Timer? _hideTimer;

  final List<String> _qualities = ['360p', '480p', '720p', '1080p'];
  String _selectedQuality = '720p';
  final List<double> _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _initPlayer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _initPlayer() async {
    _controller = VideoPlayerController.network(
      widget.url,
      httpHeaders: {
        "Referer": "https://animepahe.si",
        "User-Agent": "Mozilla/5.0",
      },
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
          _isBuffering = _controller.value.isBuffering;
          _position = _formatDuration(_controller.value.position);
        });
      }
    });

    try {
      await _controller.initialize();
      await _controller.play();
      setState(() {
        _isInitialized = true;
        _isPlaying = true;
        _duration = _formatDuration(_controller.value.duration);
      });
      _startHideTimer();
    } catch (e) {
      debugPrint('Video error: $e');
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
        _startHideTimer();
      }
    });
  }

  void _skip(int seconds) {
    final pos = _controller.value.position + Duration(seconds: seconds);
    final max = _controller.value.duration;
    if (pos < Duration.zero) {
      _controller.seekTo(Duration.zero);
    } else if (pos > max) {
      _controller.seekTo(max);
    } else {
      _controller.seekTo(pos);
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    if (_isPlaying) {
      _hideTimer = Timer(const Duration(seconds: 4), () {
        if (mounted && _isPlaying) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Video
            Center(
              child: _isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : const SizedBox(),
            ),

            // Buffering
            if (_isBuffering)
              const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),

            // Center Play Icon
            if (!_isPlaying && !_isBuffering && _isInitialized)
              Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Double tap zones
            if (_isInitialized)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onDoubleTap: () => _skip(-10),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onDoubleTap: () => _skip(10),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ],
              ),

            // Controls
            if (_showControls && _isInitialized)
              AnimatedOpacity(
                opacity: _showControls ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0, 0.2, 0.7, 1],
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTopBar(),
                      const Spacer(),
                      _buildBottomBar(),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.cast, color: Colors.white, size: 26),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final pos = _controller.value.position.inMilliseconds.toDouble();
    final dur = _controller.value.duration.inMilliseconds.toDouble();
    final buffered = _controller.value.buffered.isNotEmpty
        ? _controller.value.buffered.last.end.inMilliseconds.toDouble()
        : 0.0;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress bar
            Stack(
              children: [
                // Buffered track
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (buffered / dur).clamp(0.0, 1.0),
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                    activeTrackColor: const Color(0xFFE50914),
                    inactiveTrackColor: Colors.transparent,
                    thumbColor: const Color(0xFFE50914),
                  ),
                  child: Slider(
                    value: pos.clamp(0.0, dur),
                    min: 0,
                    max: dur,
                    onChanged: (val) {
                      _controller.seekTo(Duration(milliseconds: val.round()));
                    },
                    onChangeStart: (_) => _hideTimer?.cancel(),
                    onChangeEnd: (_) => _startHideTimer(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Time + Controls
            Row(
              children: [
                Text(
                  '$_position / $_duration',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.replay_10, color: Colors.white, size: 28),
                  onPressed: () => _skip(-10),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: _togglePlayPause,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.forward_10, color: Colors.white, size: 28),
                  onPressed: () => _skip(10),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.subtitles_outlined, color: Colors.white, size: 26),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 26),
                  onPressed: _showSettings,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2a2a2a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingItem('Quality', _selectedQuality, () {
              Navigator.pop(context);
              _showQualityPicker();
            }),
            _buildSettingItem('Speed', '${_playbackSpeed}x', () {
              Navigator.pop(context);
              _showSpeedPicker();
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String label, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showQualityPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2a2a2a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ..._qualities.map((q) => ListTile(
              title: Text(
                q,
                style: TextStyle(
                  color: q == _selectedQuality ? const Color(0xFFE50914) : Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: q == _selectedQuality
                  ? const Icon(Icons.check, color: Color(0xFFE50914))
                  : null,
              onTap: () {
                setState(() => _selectedQuality = q);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSpeedPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2a2a2a),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ..._speeds.map((s) => ListTile(
              title: Text(
                '${s}x',
                style: TextStyle(
                  color: s == _playbackSpeed ? const Color(0xFFE50914) : Colors.white,
                  fontSize: 16,
                ),
              ),
              trailing: s == _playbackSpeed
                  ? const Icon(Icons.check, color: Color(0xFFE50914))
                  : null,
              onTap: () {
                setState(() => _playbackSpeed = s);
                _controller.setPlaybackSpeed(s);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}