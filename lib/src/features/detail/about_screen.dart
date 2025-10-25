import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx21-ELSYx3yMPcKM.jpg",
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),

            // Text + info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
                        "when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
                        "It has survived not only five centuries, but also the leap into electronic typesetting, "
                        "remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset "
                        "sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like "
                        "Aldus PageMaker including versions of Lorem Ipsum.",
                    style: TextStyle(
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
                    _buildChip("2020"),
                  ]),
                  _buildInfoRow("Davlat", [
                    _buildChip("AQSH"),
                    _buildChip("Fransiya"),
                  ]),
                  _buildInfoRow("Davomiyligi", [
                    const Text(
                      "1 soat 40 daqiqa",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                  _buildInfoRow("Janr", [
                    _buildChip("Fantasiya"),
                    _buildChip("Jangari"),
                    _buildChip("Dramma"),
                  ]),
                  _buildInfoRow("Reyting", [
                    const Text(
                      "IMDb ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      "8.7",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ]),
                  _buildInfoRow("Tili", [
                    const Text(
                      "Russ tili, O‘zbekcha",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
