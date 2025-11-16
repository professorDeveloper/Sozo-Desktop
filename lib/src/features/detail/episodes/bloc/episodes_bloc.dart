// lib/bloc/episode/episode_bloc.dart
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sozodesktop/src/features/detail/episodes/bloc/episodes_state.dart';
import '../../../../parser/anime_paphe.dart';
import '../../../../parser/models/episode_data.dart';
import 'episodes_event.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final AnimePahe _parser = AnimePahe();

  EpisodeBloc() : super(EpisodeInitial()) {
    on<LoadEpisodes>(_onLoad);
  }

  Future<void> _onLoad(
      LoadEpisodes event,
      Emitter<EpisodeState> emit,
      ) async {
    emit(EpisodeLoading());
    try {
      final searchResults = await _parser.search(event.query);
      if (searchResults.isEmpty) {
        return emit(const EpisodeError('Nothing found'));
      }

      // Choose the best match
      final match = searchResults.firstWhere(
            (r) => r.name.toLowerCase().contains(event.query.toLowerCase()),
        orElse: () => searchResults.first,
      );

      // -----------------------------------------------------------------
      // 1. Load **all** pages for this anime
      // -----------------------------------------------------------------
      final rawEpisodes = <Data>[];
      int page = 1;
      while (true) {
        final data = await _parser.loadEpisodes(match.link, page);
        if (data?.data == null || data!.data!.isEmpty) break;
        rawEpisodes.addAll(data.data!);
        if (data.nextPageUrl == null) break;
        page++;
      }

      // -----------------------------------------------------------------
      // 2. Group by season (field `season` in Data)
      // -----------------------------------------------------------------
      final Map<int, List<Data>> grouped = {};
      for (final ep in rawEpisodes) {
        final season = ep.season ?? 1; // fallback to 1
        grouped.putIfAbsent(season, () => []).add(ep);
      }

      // Sort seasons ascending
      final sortedSeasons = grouped.keys.toList()..sort();

      final List<String> seasonNames = sortedSeasons
          .map((s) => '$s-Mavsum')
          .toList();

      final List<List<Map<String, String>>> episodesBySeason = [];

      for (final season in sortedSeasons) {
        final eps = grouped[season]!
            .map((e) => {
          "title":
          '${e.episode}-episode${e.title != null ? ' ${e.title}' : ''}',
          "image": e.snapshot ??
              'https://via.placeholder.com/300x200',
          "session": e.session ?? '',
          "animeSession": match.link,
        })
            .toList();
        episodesBySeason.add(eps);
      }

      emit(EpisodeLoaded(seasonNames, episodesBySeason));
    } catch (e) {
      emit(EpisodeError(e.toString()));
    }
  }
}