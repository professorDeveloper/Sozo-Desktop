// episodes_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sozodesktop/src/core/constants/app_color.dart';
import 'package:sozodesktop/src/core/model/responses/media.dart';

import 'bloc/episodes_bloc.dart';
import 'bloc/episodes_event.dart';
import 'bloc/episodes_state.dart';

class EpisodesScreen extends StatefulWidget {
  final Media anime;
  const EpisodesScreen({super.key, required this.anime});

  @override
  State<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // fire the BLoC event with english title
    context
        .read<EpisodeBloc>()
        .add(LoadEpisodes(widget.anime.title!.english.toString()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: Text(
          widget.anime.title!.english.toString(),
          style: GoogleFonts.rubik(color: Colors.white),
        ),
      ),
      body: BlocBuilder<EpisodeBloc, EpisodeState>(
        builder: (context, state) {
          // ---------- LOADING ----------
          if (state is EpisodeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.Red2),
            );
          }

          // ---------- ERROR ----------
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
                    onPressed: () => context
                        .read<EpisodeBloc>()
                        .add(LoadEpisodes(widget.anime.title!.english.toString())),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // ---------- SUCCESS ----------
          if (state is EpisodeLoaded) {
            final seasons = state.seasons;
            final episodes = state.episodes;
            _tabController =
                TabController(length: seasons.length, vsync: this);

            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.Gray2,
                  indicatorPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  labelStyle: GoogleFonts.rubik(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: GoogleFonts.rubik(
                      fontSize: 15, fontWeight: FontWeight.w400),
                  tabs: seasons.map((s) => Tab(text: s)).toList(),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: List.generate(
                      seasons.length,
                          (seasonIdx) => LayoutBuilder(
                        builder: (context, constraints) {
                          const double itemWidth = 150;
                          final int crossAxisCount = (constraints.maxWidth /
                              itemWidth)
                              .floor()
                              .clamp(2, 8);

                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              itemCount: episodes[seasonIdx].length,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.4,
                              ),
                              itemBuilder: (context, index) {
                                final ep = episodes[seasonIdx][index];
                                return Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(13),
                                        color: AppColors.Gray3,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(13),
                                        child: Image.network(
                                          ep["image"]!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 120,
                                          errorBuilder:
                                              (_, __, ___) => Container(
                                            height: 120,
                                            color: Colors.grey[800],
                                            child: const Icon(Icons.movie,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ep["title"]!,
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // ---------- INITIAL ----------
          return const Center(
              child: Text('Start loading…',
                  style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }
}