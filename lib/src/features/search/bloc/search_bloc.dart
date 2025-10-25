import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sozodesktop/src/features/home/repository/home_repository.dart';
import 'package:sozodesktop/src/features/search/bloc/search_event.dart';
import '../../../di/get_it.dart' as di;
import '../../home/model/home_anime_model.dart';
import '../repository/search_repository.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository = di.getIt<SearchRepository>();
  final HomeRepository homeRepository = di.getIt<HomeRepository>();

  SearchBloc() : super(SearchInitial()) {
    // Register all event handlers
    on<FetchTrendingAnime>(_onFetchTrendingAnime);
    on<PerformSearch>(_onPerformSearch);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onFetchTrendingAnime(
      FetchTrendingAnime event,
      Emitter<SearchState> emit,
      ) async {
    emit(SearchTrendingLoading([]));
    try {
      final trendingAnime = await homeRepository.getMostFavourite();
      final trending = trendingAnime.data as List<HomeAnimeModel>? ?? [];
      emit(SearchTrendingLoading(trending));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onPerformSearch(
      PerformSearch event,
      Emitter<SearchState> emit,
      ) async {
    if (event.query.isEmpty) {
      emit(SearchEmpty());
      return;
    }

    emit(SearchLoading());

    try {
      final response = await repository.searchAnime(event.query);

      if (response.errorText.isNotEmpty) {
        emit(SearchError(response.errorText));
        return;
      }

      final results = response.data ?? [];
      if (results.isEmpty) {
        emit(SearchEmpty());
      } else {
        emit(SearchLoaded(results));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    // Clear search and reload trending anime
    add(FetchTrendingAnime());
  }
}