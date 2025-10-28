abstract class CategoriesEvent {}

class LoadAllAnime extends CategoriesEvent {}

class LoadMoreAnime extends CategoriesEvent {}

class LoadGenres extends CategoriesEvent {}

class LoadGenreAnime extends CategoriesEvent {
  final String genre;

  LoadGenreAnime({required this.genre});
}

class LoadMoreGenreAnime extends CategoriesEvent {}
