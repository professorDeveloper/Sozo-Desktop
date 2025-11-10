// lib/models/episode_data.dart
class EpisodeData {
  final int? currentPage;
  final List<Data>? data;
  final int? from;
  final int? lastPage;
  final String? nextPageUrl;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  EpisodeData({
    this.currentPage,
    this.data,
    this.from,
    this.lastPage,
    this.nextPageUrl,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory EpisodeData.fromJson(Map<String, dynamic> json) => EpisodeData(
    currentPage: json['current_page'],
    data: (json['data'] as List?)?.map((e) => Data.fromJson(e)).toList(),
    from: json['from'],
    lastPage: json['last_page'],
    nextPageUrl: json['next_page_url'],
    perPage: json['per_page'] ?? 0,
    prevPageUrl: json['prev_page_url'],
    to: json['to'] ?? 0,
    total: json['total'] ?? 0,
  );
}

class Data {
  final int? animeId;
  final String? audio;
  final String? createdAt;
  final String? disc;
  final String? duration;
  final String? edition;
  final int? episode;
  final int? episode2;
  final int? filler;
  final int? id;
  final String? session;
  final String? snapshot;
  final String? title;
  final int season;

  Data({
    this.animeId,
    this.audio,
    this.createdAt,
    this.disc,
    this.duration,
    this.edition,
    this.episode,
    this.episode2,
    this.filler,
    this.id,
    this.session,
    this.snapshot,
    this.title,
    this.season = 0,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    animeId: json['anime_id'],
    audio: json['audio'],
    createdAt: json['created_at'],
    disc: json['disc'],
    duration: json['duration'],
    edition: json['edition'],
    episode: json['episode'],
    episode2: json['episode2'],
    filler: json['filler'],
    id: json['id'],
    session: json['session'],
    snapshot: json['snapshot'],
    title: json['title'],
    season: json['season'] ?? 0,
  );
}

class AnimePaheData {
  final int currentPage;
  final List<DataD> data;
  final int from;
  final int lastPage;
  final int perPage;
  final int to;
  final int total;

  AnimePaheData({
    required this.currentPage,
    required this.data,
    required this.from,
    required this.lastPage,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory AnimePaheData.fromJson(Map<String, dynamic> json) => AnimePaheData(
    currentPage: json['current_page'],
    data: (json['data'] as List).map((e) => DataD.fromJson(e)).toList(),
    from: json['from'],
    lastPage: json['last_page'],
    perPage: json['per_page'],
    to: json['to'],
    total: json['total'],
  );
}

class DataD {
  final int episodes;
  final int? id;
  final String? poster;
  final double? score;
  final String? season;
  final String? session;
  final String? status;
  final String? title;
  final String? type;
  final int? year;

  DataD({
    required this.episodes,
    this.id,
    this.poster,
    this.score,
    this.season,
    this.session,
    this.status,
    this.title,
    this.type,
    this.year,
  });

  factory DataD.fromJson(Map<String, dynamic> json) => DataD(
    episodes: json['episodes'],
    id: json['id'],
    poster: json['poster'],
    score: json['score']?.toDouble(),
    season: json['season'],
    session: json['session'],
    status: json['status'],
    title: json['title'],
    type: json['type'],
    year: json['year'],
  );
}