import '../../home/model/home_anime_model.dart';

abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

// Anime Tab States
class CategoriesAnimeLoaded extends CategoriesState {
  final List<HomeAnimeModel> animeList;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  CategoriesAnimeLoaded({
    required this.animeList,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  CategoriesAnimeLoaded copyWith({
    List<HomeAnimeModel>? animeList,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CategoriesAnimeLoaded(
      animeList: animeList ?? this.animeList,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

// Genre Tab States
class CategoriesGenresLoaded extends CategoriesState {
  final List<String> genres;

  CategoriesGenresLoaded({required this.genres});
}

class CategoriesGenreAnimeLoading extends CategoriesState {
  final String genre;

  CategoriesGenreAnimeLoading({required this.genre});
}

class CategoriesGenreAnimeLoaded extends CategoriesState {
  final String genre;
  final List<HomeAnimeModel> animeList;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  CategoriesGenreAnimeLoaded({
    required this.genre,
    required this.animeList,
    required this.currentPage,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  CategoriesGenreAnimeLoaded copyWith({
    String? genre,
    List<HomeAnimeModel>? animeList,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CategoriesGenreAnimeLoaded(
      genre: genre ?? this.genre,
      animeList: animeList ?? this.animeList,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CategoriesError extends CategoriesState {
  final String message;
  final String? genre; // Optional genre for genre-specific errors

  CategoriesError({required this.message, this.genre});
}
