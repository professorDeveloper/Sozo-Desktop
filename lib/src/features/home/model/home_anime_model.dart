class HomeAnimeModel {
  final int id;
  final String? format;
  final int? episodes;
  final List<String>? genres;
  final String? season;
  final int? seasonYear;
  final CoverImage? coverImage;
  final Title? title;
  final String? bannerImage;
  final String? description;

  HomeAnimeModel({
    required this.id,
    this.format,
    this.episodes,
    this.genres,
    this.coverImage,
    this.season,
    this.seasonYear,
    this.title,
    this.bannerImage,
    this.description,
  });

  factory HomeAnimeModel.fromJson(Map<String, dynamic> json) {
    return HomeAnimeModel(
      id: json['id'] as int,
      format: json['format'] ?? "TV",
      episodes: json['episodes'] != null
          ? (json['episodes'] is int
          ? json['episodes'] as int
          : int.tryParse(json['episodes'].toString()))
          : 25,
      genres: json['genres'] != null
          ? List<String>.from(json['genres'])
          : ["Action", "Drama", "Fantasy"],
      season: json['season'] ?? "FALL",
      seasonYear: json['seasonYear'] != null
          ? (json['seasonYear'] is int
          ? json['seasonYear'] as int
          : int.tryParse(json['seasonYear'].toString()))
          : 2013,
      coverImage: json['coverImage'] != null
          ? CoverImage.fromJson(json['coverImage'])
          : CoverImage(
          large:
          "https://via.placeholder.com/300x450.png?text=No+Cover"),
      title: json['title'] != null
          ? Title.fromJson(json['title'])
          : Title(english: "Unknown"),
      bannerImage: (json['bannerImage'] != null &&
          (json['bannerImage'] as String).isNotEmpty)
          ? json['bannerImage']
          : "https://via.placeholder.com/600x200.png?text=No+Banner",
      description: json['description'] ?? "No description available.",
    );
  }
}

class CoverImage {
  final String? large;
  final String? medium;
  final String? extraLarge;

  CoverImage({this.large, this.medium, this.extraLarge});

  factory CoverImage.fromJson(Map<String, dynamic> json) {
    return CoverImage(
      large: (json['large'] as String?)?.isNotEmpty == true
          ? json['large']
          : "https://via.placeholder.com/300x450.png?text=No+Cover",
      medium: json['medium'] ?? "",
      extraLarge: json['extraLarge'] ?? "",
    );
  }
  @override
  String toString() {
  return 'CoverImage(large: $large, medium: $medium, extraLarge: $extraLarge)';
  }

}

class Title {
  final String? english;

  Title({this.english});

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      english: json['english'] ?? "Unknown",
    );
  }
}
