import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_color.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  bool _notifications = true;
  bool _autoUpdate = true;
  bool _downloadOverWifi = true;
  bool _dataSync = false;
  String _language = 'English';
  String _downloadQuality = '720p';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Settings',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'App preferences and configurations',
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.5),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingsCard([
            _buildIconToggle(
              CupertinoIcons.bell_fill,
              'Notifications',
              'Get updates and alerts',
              _notifications,
              (v) => setState(() => _notifications = v),
            ),
            _buildIconToggle(
              CupertinoIcons.arrow_down_circle_fill,
              'Auto Update',
              'Update app automatically',
              _autoUpdate,
              (v) => setState(() => _autoUpdate = v),
            ),
            _buildIconToggle(
              CupertinoIcons.wifi,
              'Download Over WiFi Only',
              'Prevent mobile data usage',
              _downloadOverWifi,
              (v) => setState(() => _downloadOverWifi = v),
            ),
            _buildIconToggle(
              CupertinoIcons.cloud_upload_fill,
              'Data Sync',
              'Sync across devices',
              _dataSync,
              (v) => setState(() => _dataSync = v),
            ),
          ]),

          const SizedBox(height: 16),

          _buildSettingsCard([
            _buildIconSelector(
              CupertinoIcons.globe,
              'Language',
              'App display language',
              _language,
              ['English', 'Japanese', 'Spanish', 'French', 'German'],
            ),
            _buildIconSelector(
              CupertinoIcons.arrow_down_doc_fill,
              'Download Quality',
              'Default download quality',
              _downloadQuality,
              ['360p', '480p', '720p', '1080p'],
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
                  if (title == 'Language') _language = value!;
                  if (title == 'Download Quality') _downloadQuality = value!;
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
