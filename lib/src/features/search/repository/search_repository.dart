import 'package:meta/meta.dart';
import '../../../core/network/network_response.dart';
import '../../home/model/home_anime_model.dart';

@immutable
abstract class SearchRepository {
  Future<NetworkResponse<List<HomeAnimeModel>>> searchAnime(String query);
}