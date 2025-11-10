// lib/bloc/episode/episode_bloc.dart
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:sozodesktop/src/features/detail/episodes/bloc/episodes_state.dart';

import '../../../../parser/anime_paphe.dart';
import 'episodes_event.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final AnimePahe _parser = AnimePahe();

  EpisodeBloc() : super(EpisodeInitial()) {
    on<LoadEpisodes>(_onLoad);
  }

  Future<void> _onLoad(LoadEpisodes event, Emitter<EpisodeState> emit) async {
    emit(EpisodeLoading());
    try {
      // 1. SEARCH
      final searchResults = await _parser.search(event.query);
      if (searchResults.isEmpty) {
        return emit(const EpisodeError('Nothing found'));
      }

      // pick first result that contains the query (case-insensitive)
      final match = searchResults.firstWhere(
        (r) => r.name.toLowerCase().contains(event.query.toLowerCase()),
        orElse: () => searchResults.first,
      );

      // 2. LOAD ALL EPISODES (paginated)
      final all = <Map<String, String>>[];
      int page = 1;
      while (true) {
        final data = await _parser.loadEpisodes(match.link, page);
        if (data?.data == null || data!.data!.isEmpty) break;

        all.addAll(
          data.data!.map(
            (e) => {
              "title":
                  "Ep ${e.episode}${e.title != null ? ': ${e.title}' : ''}",
              "image": e.snapshot ?? "https://via.placeholder.com/300x200",
            },
          ),
        );

        if (data.nextPageUrl == null) break;
        page++;
      }

      // 3. SINGLE SEASON (you can extend to multi-season later)
      final seasons = ["1-Mavsum"];
      final episodes = [all];

      emit(EpisodeLoaded(seasons, episodes));
    } catch (e) {
      emit(EpisodeError(e.toString()));
    }
  }
}
