import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/categories_repository.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository repository;

  CategoriesBloc({required this.repository}) : super(CategoriesInitial()) {
    on<LoadAllAnime>(_onLoadAllAnime);
    on<LoadMoreAnime>(_onLoadMoreAnime);
    on<LoadGenres>(_onLoadGenres);
    on<LoadGenreAnime>(_onLoadGenreAnime);
    on<LoadMoreGenreAnime>(_onLoadMoreGenreAnime);
  }

  Future<void> _onLoadAllAnime(
    LoadAllAnime event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading());
    try {
      final animeList = await repository.fetchAllAnime(page: 1);
      emit(
        CategoriesAnimeLoaded(
          animeList: animeList,
          currentPage: 1,
          hasMore: animeList.length >= 20,
        ),
      );
    } catch (e) {
      emit(CategoriesError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreAnime(
    LoadMoreAnime event,
    Emitter<CategoriesState> emit,
  ) async {
    if (state is CategoriesAnimeLoaded) {
      final currentState = state as CategoriesAnimeLoaded;

      if (!currentState.hasMore || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final nextPage = currentState.currentPage + 1;
        final moreAnime = await repository.fetchAllAnime(page: nextPage);

        emit(
          CategoriesAnimeLoaded(
            animeList: [...currentState.animeList, ...moreAnime],
            currentPage: nextPage,
            hasMore: moreAnime.length >= 20,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  Future<void> _onLoadGenres(
    LoadGenres event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading());
    try {
      final genres = await repository.fetchGenres();
      emit(CategoriesGenresLoaded(genres: genres));
    } catch (e) {
      emit(CategoriesError(message: e.toString()));
    }
  }

  Future<void> _onLoadGenreAnime(
    LoadGenreAnime event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesGenreAnimeLoading(genre: event.genre));
    try {
      final animeList = await repository.fetchAnimeByGenre(
        genre: event.genre,
        page: 1,
      );
      emit(
        CategoriesGenreAnimeLoaded(
          genre: event.genre,
          animeList: animeList,
          currentPage: 1,
          hasMore: animeList.length >= 20,
        ),
      );
    } catch (e) {
      emit(CategoriesError(message: e.toString(), genre: event.genre));
    }
  }

  Future<void> _onLoadMoreGenreAnime(
    LoadMoreGenreAnime event,
    Emitter<CategoriesState> emit,
  ) async {
    if (state is CategoriesGenreAnimeLoaded) {
      final currentState = state as CategoriesGenreAnimeLoaded;

      if (!currentState.hasMore || currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final nextPage = currentState.currentPage + 1;
        final moreAnime = await repository.fetchAnimeByGenre(
          genre: currentState.genre,
          page: nextPage,
        );

        emit(
          CategoriesGenreAnimeLoaded(
            genre: currentState.genre,
            animeList: [...currentState.animeList, ...moreAnime],
            currentPage: nextPage,
            hasMore: moreAnime.length >= 20,
            isLoadingMore: false,
          ),
        );
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }
}
