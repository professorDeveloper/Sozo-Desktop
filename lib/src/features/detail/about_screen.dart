import 'package:flutter/material.dart';
import 'package:sozodesktop/src/core/model/responses/media.dart';

class AboutScreen extends StatefulWidget {
  final Media anime;

  const AboutScreen({super.key, required this.anime});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildInfoRow(String title, List<Widget> values) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Wrap(children: values),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Media anime = widget.anime;
    String description = anime.description ?? 'No description available';
    // Basic HTML cleanup
    description = description
        .replaceAll('<br>', '\n')
        .replaceAll('<b>', '')
        .replaceAll('</b>', '');

    return Scaffold(
      backgroundColor: const Color(0xFF0D0E10),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 44),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Container(
              width: 350,
              height: 570,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    anime.coverImage?.large ?? 'https://via.placeholder.com/350x570',
                  ),
                  onError: (exception, stackTrace) => const AssetImage('assets/placeholder.jpg'),
                ),
              ),
            ),
            const SizedBox(width: 24),

            // Text + info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF8B9498),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 16),

                  // Info rows
                  _buildInfoRow("Ishlab chiqilgan sana", [
                    _buildChip(anime.seasonYear?.toString() ?? 'N/A'),
                  ]),
                  _buildInfoRow("Davlat", [
                    _buildChip(anime.countryOfOrigin ?? 'N/A'),
                  ]),
                  _buildInfoRow("Davomiyligi", [
                    const Text(
                      "N/A", // Duration not available in Media model
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                  _buildInfoRow("Janr", anime.genres?.map((genre) => _buildChip(genre)).toList() ?? []),
                  _buildInfoRow("Reyting", [
                    const Text(
                      "IMDb ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${(anime.meanScore ?? 0) / 10}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ]),
                  _buildInfoRow("Tili", [
                    const Text(
                      "Russ tili, O‘zbekcha", // Hardcoded as not in Media model
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]),
                  if (anime.studios?.nodes != null)
                    _buildInfoRow(
                      "Studios",
                      anime.studios!.nodes!.map((studio) => _buildChip(studio.name ?? 'N/A')).toList(),
                    ),
                  if (anime.staff?.nodes != null)
                    _buildInfoRow(
                      "Staff",
                      anime.staff!.nodes!.map((staff) => _buildChip(staff.name?.userPreferred ?? 'N/A')).toList(),
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