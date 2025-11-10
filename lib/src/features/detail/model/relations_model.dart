// relations_model.dart
import '../../home/model/home_anime_model.dart';

class RelationsAnimeModel {
  final int id;
  final String? title;
  final String? image;
  final List<String>? genres;
  final int? meanScore;
  final int? averageScore;

  RelationsAnimeModel({
    required this.id,
    this.title,
    this.image,
    this.genres,
    this.meanScore,
    this.averageScore,
  });

  factory RelationsAnimeModel.fromJson(Map<String, dynamic> json) {
    final media = json['media'] as Map<String, dynamic>? ?? {};

    return RelationsAnimeModel(
      id: media['id'] as int? ?? 0,
      title: (media['title'] as Map<String, dynamic>?)?['english'] as String?,
      image: (media['coverImage'] as Map<String, dynamic>?)?['large'] as String?,
      genres: media['genres'] != null
          ? List<String>.from(media['genres'] as List)
          : null,
      meanScore: media['meanScore'] as int?,
      averageScore: media['averageScore'] as int?,
    );
  }


  @override
  String toString() {
    return 'RelationsAnimeModel(id: $id, title: $title, genres: $genres)';
  }
}