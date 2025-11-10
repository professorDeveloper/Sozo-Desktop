import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sozodesktop/src/core/constants/app_color.dart';
import 'package:sozodesktop/src/core/model/responses/media.dart';
import 'package:sozodesktop/src/features/detail/model/relations_model.dart';


class AboutScreen extends StatefulWidget {
  final Media anime;

  const AboutScreen({super.key, required this.anime});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(children: content),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Media anime = widget.anime;
    String description = anime.description ?? 'No description available';

    // HTML cleanup
    description = description
        .replaceAll('<br>', '')
        .replaceAll('<b>', '')
        .replaceAll('</b>', '')
        .replaceAll(RegExp(r'<[^>]*>'), '');

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 300,
                height: 450,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      anime.coverImage?.extraLarge ??
                          'https://via.placeholder.com/340x500',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 15,
                      height: 1.6,
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Info sections
                  _buildInfoSection("Release Date", [
                    _buildChip(anime.seasonYear?.toString() ?? 'N/A'),
                  ]),

                  _buildInfoSection("Country", [
                    _buildChip(anime.countryOfOrigin ?? 'AQSH'),
                    if (anime.countryOfOrigin != null &&
                        anime.countryOfOrigin != 'JP')
                      _buildChip('Fransiya'),
                  ]),

                  _buildInfoSection("Rating", [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Anilist:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${(anime.meanScore ?? 0) / 10}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ]),

                  if (anime.genres != null && anime.genres!.isNotEmpty)
                    _buildInfoSection(
                      "Genre",
                      anime.genres!.map((genre) => _buildChip(genre)).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}

