import '../../home/model/home_anime_model.dart';

abstract class CategoriesRepository {
  Future<List<HomeAnimeModel>> fetchAllAnime({required int page});
  Future<List<String>> fetchGenres();
  Future<List<HomeAnimeModel>> fetchAnimeByGenre({
    required String genre,
    required int page,
  });
}
