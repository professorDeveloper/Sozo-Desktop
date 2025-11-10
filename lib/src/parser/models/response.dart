// lib/models/show_response.dart
enum AudioType { sub, dub }

class ShowResponse {
  final String name;
  final String link;
  final String coverUrl;
  final List<String> otherNames;
  final int? total;
  final Map<String, String>? extra;
  final List<int> seasons;

  ShowResponse({
    required this.name,
    required this.link,
    required this.coverUrl,
    this.otherNames = const [],
    this.total,
    this.extra,
    this.seasons = const [],
  });

  factory ShowResponse.fromJson(Map<String, dynamic> json) => ShowResponse(
    name: json['name'] ?? '',
    link: json['link'] ?? '',
    coverUrl: json['coverUrl'] ?? '',
    otherNames: List<String>.from(json['otherNames'] ?? []),
    total: json['total'],
    extra: json['extra'] != null ? Map<String, String>.from(json['extra']) : null,
    seasons: List<int>.from(json['seasons'] ?? []),
  );
}

class VideoOption {
  final String kwikUrl;
  final String fansub;
  final String resolution;
  final AudioType audioType;
  final String quality;
  final bool isActive;
  final String fullText;

  VideoOption({
    required this.kwikUrl,
    required this.fansub,
    required this.resolution,
    required this.audioType,
    required this.quality,
    required this.isActive,
    required this.fullText,
  });
}