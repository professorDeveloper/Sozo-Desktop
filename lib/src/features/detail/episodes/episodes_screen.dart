// episodes_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sozodesktop/src/core/constants/app_color.dart';
import 'package:sozodesktop/src/core/model/responses/media.dart';
import 'package:sozodesktop/src/features/watch/watch_screen.dart';

import '../../../parser/anime_paphe.dart';
import 'bloc/episodes_bloc.dart';
import 'bloc/episodes_event.dart';
import 'bloc/episodes_state.dart';

class EpisodesScreen extends StatefulWidget {
  final Media anime;
  const EpisodesScreen({super.key, required this.anime});

  @override
  State<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<EpisodeBloc>()
        .add(LoadEpisodes(widget.anime.title!.english.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: Text(
          widget.anime.title!.english.toString(),
          style: GoogleFonts.rubik(color: Colors.white),
        ),
      ),
      body: BlocBuilder<EpisodeBloc, EpisodeState>(
        builder: (context, state) {
          // ------------------- Loading -------------------
          if (state is EpisodeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.Red2),
            );
          }

          // ------------------- Error -------------------
          if (state is EpisodeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(state.message,
                      style: GoogleFonts.rubik(color: Colors.white)),
                  ElevatedButton(
                    onPressed: () => context.read<EpisodeBloc>().add(
                        LoadEpisodes(
                            widget.anime.title!.english.toString())),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // ------------------- Loaded -------------------
          if (state is EpisodeLoaded) {
            // We only use the first (and only) list of episodes
            final episodes = state.episodes[0];

            return _buildEpisodeGrid(episodes);
          }

          return const Center(
            child: Text('Start loading…',
                style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }

  // --------------------------------------------------------------
  // Grid with all episodes (no season tabs)
  // --------------------------------------------------------------
  Widget _buildEpisodeGrid(List<Map<String, String>> episodeList) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double itemWidth = 150;
        final int crossAxisCount =
        (constraints.maxWidth / itemWidth).floor().clamp(2, 8);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GridView.builder(
            itemCount: episodeList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              final ep = episodeList[index];
              return InkWell(
                borderRadius: BorderRadius.circular(13),
                onTap: () {
                  // ----> Replace with your real player screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => WatchScreen(
                        animeTitle: widget.anime.title!.english!,
                        episodeTitle: ep['title']!,
                        session: ep['session']!,
                        animeSession: ep['animeSession']!,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.network(
                        ep['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 120,
                        errorBuilder: (_, __, ___) => Container(
                          height: 120,
                          color: Colors.grey[800],
                          child:
                          const Icon(Icons.movie, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ep['title']!,
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

