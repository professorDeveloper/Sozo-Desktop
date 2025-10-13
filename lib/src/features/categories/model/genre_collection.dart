class GenreCollection {
  final List<String> genres;

  GenreCollection({required this.genres});

  factory GenreCollection.fromJson(Map<String, dynamic> json) {
    return GenreCollection(
      genres: List<String>.from(json['data']['GenreCollection']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'GenreCollection': genres,
      },
    };
  }
}