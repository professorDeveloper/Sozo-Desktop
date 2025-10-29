import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_color.dart';

class AppearanceSettingsContent extends StatefulWidget {
  const AppearanceSettingsContent({super.key});

  @override
  State<AppearanceSettingsContent> createState() =>
      _AppearanceSettingsContentState();
}

class _AppearanceSettingsContentState extends State<AppearanceSettingsContent> {
  String _theme = 'Dark';
  String _accentColor = 'Blue';
  bool _compactMode = false;
  bool _animations = true;
  double _fontSize = 1.0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance Settings',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize how your app looks',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingsCard([
            _buildIconSelector(
              CupertinoIcons.moon_fill,
              'Theme Mode',
              'Choose your preferred theme',
              _theme,
              ['Light', 'Dark', 'System'],
            ),
            _buildColorSelector(),
          ]),

          const SizedBox(height: 16),

          _buildSettingsCard([
            _buildIconToggle(
              CupertinoIcons.rectangle_compress_vertical,
              'Compact Mode',
              'Reduce spacing between elements',
              _compactMode,
              (v) => setState(() => _compactMode = v),
            ),
            _buildIconToggle(
              CupertinoIcons.sparkles,
              'Animations',
              'Enable smooth transitions',
              _animations,
              (v) => setState(() => _animations = v),
            ),
            _buildFontSizeSlider(),
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

  Widget _buildColorSelector() {
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
            child: const Icon(
              CupertinoIcons.color_filter,
              color: AppColors.Red,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accent Color',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Choose your favorite color',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildColorDot(AppColors.Red, 'Blue'),
              const SizedBox(width: 8),
              _buildColorDot(Colors.purple, 'Purple'),
              const SizedBox(width: 8),
              _buildColorDot(Colors.red, 'Red'),
              const SizedBox(width: 8),
              _buildColorDot(Colors.green, 'Green'),
              const SizedBox(width: 8),
              _buildColorDot(Colors.pink, 'Pink'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorDot(Color color, String name) {
    final isSelected = _accentColor == name;
    return InkWell(
      onTap: () => setState(() => _accentColor = name),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: isSelected
            ? const Icon(
                CupertinoIcons.check_mark,
                color: Colors.white,
                size: 14,
              )
            : null,
      ),
    );
  }

  Widget _buildFontSizeSlider() {
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
            child: const Icon(
              CupertinoIcons.textformat_size,
              color: AppColors.Red,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Font Size',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _getFontSizeLabel(_fontSize),
                      style: GoogleFonts.inter(
                        color: AppColors.Red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.Red,
                    inactiveTrackColor: Colors.white.withOpacity(0.1),
                    thumbColor: AppColors.Red,
                    overlayColor: AppColors.Red.withOpacity(0.2),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: _fontSize,
                    min: 0.8,
                    max: 1.2,
                    divisions: 2,
                    onChanged: (v) => setState(() => _fontSize = v),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFontSizeLabel(double value) {
    if (value <= 0.8) return 'Small';
    if (value >= 1.2) return 'Large';
    return 'Medium';
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
                setState(() => _theme = value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
