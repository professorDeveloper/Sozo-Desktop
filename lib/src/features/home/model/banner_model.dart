class BannerDataModel {
  final int id;
  final String? format;
  final int? episodes;
  final List<String>? genres;
  final String? season;
  final int? seasonYear;
  final Title? title;
  final String? bannerImage;
  final String? description;

  BannerDataModel({
    required this.id,
    this.format,
    this.episodes,
    this.genres,
    this.season,
    this.seasonYear,
    this.title,
    this.bannerImage,
    this.description,
  });

  factory BannerDataModel.fromJson(Map<String, dynamic> json) {
    return BannerDataModel(
      id: json['id'] as int,
      format: json['format'] ?? "TV",
      episodes: json['episodes'] != null
          ? (json['episodes'] is int ? json['episodes'] as int : int.tryParse(json['episodes'].toString()))
          : 25,
      genres: json['genres'] != null
          ? List<String>.from(json['genres'])
          : ["Action", "Drama", "Fantasy"],
      season: json['season'] ?? "FALL",
      seasonYear: json['seasonYear'] != null
          ? (json['seasonYear'] is int ? json['seasonYear'] as int : int.tryParse(json['seasonYear'].toString()))
          : 2013,
      title: json['title'] != null
          ? Title.fromJson(json['title'])
          : Title(english: "Attack on Titan"),
      bannerImage: json['bannerImage'] ??
          "https://s4.anilist.co/file/anilistcdn/media/anime/banner/26-FWJgAONj7etr.",
      description: json['description'] ??
          "Centuries ago, mankind was slaughtered to near extinction...",
    );
  }
}

class Title {
  final String? english;

  Title({this.english});

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      english: json['english']??"Weathering with You",
    );
  }
}