import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_color.dart';

class PlaybackSettingsScreen extends StatefulWidget {
  const PlaybackSettingsScreen({super.key});

  @override
  State<PlaybackSettingsScreen> createState() => _PlaybackSettingsScreenState();
}

class _PlaybackSettingsScreenState extends State<PlaybackSettingsScreen> {
  bool _autoPlay = true;
  bool _autoSkipIntro = true;
  bool _autoSkipOutro = false;
  bool _autoNextEpisode = true;
  bool _subtitles = true;
  bool _rememberProgress = true;
  bool _pictureInPicture = false;
  String _quality = '1080p';
  String _playbackSpeed = '1.0x';
  String _skipDuration = '10 sec';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Playback Settings',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your video playback experience',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingsCard([
            _buildIconToggle(
              CupertinoIcons.play_circle_fill,
              'Auto Play',
              'Automatically start playing next video',
              _autoPlay,
              (v) => setState(() => _autoPlay = v),
            ),
            _buildIconToggle(
              CupertinoIcons.forward_end_fill,
              'Auto Skip Intro',
              'Skip opening sequences automatically',
              _autoSkipIntro,
              (v) => setState(() => _autoSkipIntro = v),
            ),
            _buildIconToggle(
              CupertinoIcons.forward_end,
              'Auto Skip Outro',
              'Skip ending sequences automatically',
              _autoSkipOutro,
              (v) => setState(() => _autoSkipOutro = v),
            ),
            _buildIconToggle(
              CupertinoIcons.arrow_right_circle_fill,
              'Auto Next Episode',
              'Continue to next episode',
              _autoNextEpisode,
              (v) => setState(() => _autoNextEpisode = v),
            ),
          ]),

          const SizedBox(height: 16),

          _buildSettingsCard([
            _buildIconToggle(
              CupertinoIcons.textformat,
              'Subtitles',
              'Show subtitles by default',
              _subtitles,
              (v) => setState(() => _subtitles = v),
            ),
            _buildIconToggle(
              CupertinoIcons.clock_fill,
              'Remember Progress',
              'Save playback position',
              _rememberProgress,
              (v) => setState(() => _rememberProgress = v),
            ),
            _buildIconToggle(
              CupertinoIcons.rectangle_on_rectangle,
              'Picture in Picture',
              'Enable PiP mode',
              _pictureInPicture,
              (v) => setState(() => _pictureInPicture = v),
            ),
          ]),

          const SizedBox(height: 16),

          _buildSettingsCard([
            _buildIconSelector(
              CupertinoIcons.film,
              'Video Quality',
              'Default playback quality',
              _quality,
              ['360p', '480p', '720p', '1080p', '4K'],
            ),
            _buildIconSelector(
              CupertinoIcons.speedometer,
              'Playback Speed',
              'Video playback speed',
              _playbackSpeed,
              ['0.5x', '0.75x', '1.0x', '1.25x', '1.5x', '2.0x'],
            ),
            _buildIconSelector(
              CupertinoIcons.timer,
              'Skip Duration',
              'Forward/backward skip interval',
              _skipDuration,
              ['5 sec', '10 sec', '15 sec', '30 sec'],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF17171C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: children.map((child) {
          final isLast = children.last == child;
          return Column(
            children: [
              child,
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIconToggle(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.Red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.Red, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.Red,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildIconSelector(
    IconData icon,
    String title,
    String subtitle,
    String current,
    List<String> options,
  ) {
    return InkWell(
      onTap: () => _showSelector(title, current, options),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.Red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.Red, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                current,
                style: GoogleFonts.inter(
                  color: AppColors.Red,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_right,
              color: Colors.white.withOpacity(0.3),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _showSelector(String title, String current, List<String> options) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return RadioListTile<String>(
              title: Text(
                option,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              ),
              value: option,
              groupValue: current,
              activeColor: AppColors.Red,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  if (title == 'Video Quality') _quality = value!;
                  if (title == 'Playback Speed') _playbackSpeed = value!;
                  if (title == 'Skip Duration') _skipDuration = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
