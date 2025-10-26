import 'dart:convert';

Media mediaFromJson(String str) => Media.fromJson(json.decode(str));
String mediaToJson(Media data) => json.encode(data.toJson());

class Media {
  final int? id;
  final Title? title;
  final String? description;
  final int? seasonYear;
  final String? countryOfOrigin;
  final List<String>? genres;
  final int? meanScore;
  final CoverImage? coverImage;
  final StudioConnection? studios;
  final StaffConnection? staff;

  Media({
    this.id,
    this.title,
    this.description,
    this.seasonYear,
    this.countryOfOrigin,
    this.genres,
    this.meanScore,
    this.coverImage,
    this.studios,
    this.staff,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"],
    title: json["title"] != null ? Title.fromJson(json["title"]) : null,
    description: json["description"],
    seasonYear: json["seasonYear"],
    countryOfOrigin: json["countryOfOrigin"],
    genres: json["genres"] == null
        ? []
        : List<String>.from(json["genres"].map((x) => x)),
    meanScore: json["meanScore"],
    coverImage: json["coverImage"] != null
        ? CoverImage.fromJson(json["coverImage"])
        : null,
    studios: json["studios"] != null
        ? StudioConnection.fromJson(json["studios"])
        : null,
    staff: json["staff"] != null
        ? StaffConnection.fromJson(json["staff"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title?.toJson(),
    "description": description,
    "seasonYear": seasonYear,
    "countryOfOrigin": countryOfOrigin,
    "genres": genres,
    "meanScore": meanScore,
    "coverImage": coverImage?.toJson(),
    "studios": studios?.toJson(),
    "staff": staff?.toJson(),
  };
}

class Title {
  final String? english;
  final String? romaji;
  final String? nativeTitle;
  final String? userPreferred;

  Title({
    this.english,
    this.romaji,
    this.nativeTitle,
    this.userPreferred,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
    english: json["english"],
    romaji: json["romaji"],
    nativeTitle: json["native"],
    userPreferred: json["userPreferred"],
  );

  Map<String, dynamic> toJson() => {
    "english": english,
    "romaji": romaji,
    "native": nativeTitle,
    "userPreferred": userPreferred,
  };
}

class CoverImage {
  final String? extraLarge;
  final String? large;
  final String? medium;
  final String? color;

  CoverImage({
    this.extraLarge,
    this.large,
    this.medium,
    this.color,
  });

  factory CoverImage.fromJson(Map<String, dynamic> json) => CoverImage(
    extraLarge: json["extraLarge"],
    large: json["large"],
    medium: json["medium"],
    color: json["color"],
  );

  Map<String, dynamic> toJson() => {
    "extraLarge": extraLarge,
    "large": large,
    "medium": medium,
    "color": color,
  };
}

class StudioConnection {
  final List<StudioNode>? nodes;

  StudioConnection({this.nodes});

  factory StudioConnection.fromJson(Map<String, dynamic> json) =>
      StudioConnection(
        nodes: json["nodes"] == null
            ? []
            : List<StudioNode>.from(
            json["nodes"].map((x) => StudioNode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "nodes": nodes?.map((x) => x.toJson()).toList(),
  };
}

class StudioNode {
  final String? name;

  StudioNode({this.name});

  factory StudioNode.fromJson(Map<String, dynamic> json) =>
      StudioNode(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

class StaffConnection {
  final List<StaffNode>? nodes;

  StaffConnection({this.nodes});

  factory StaffConnection.fromJson(Map<String, dynamic> json) =>
      StaffConnection(
        nodes: json["nodes"] == null
            ? []
            : List<StaffNode>.from(
            json["nodes"].map((x) => StaffNode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "nodes": nodes?.map((x) => x.toJson()).toList(),
  };
}

class StaffNode {
  final StaffName? name;

  StaffNode({this.name});

  factory StaffNode.fromJson(Map<String, dynamic> json) => StaffNode(
    name: json["name"] != null ? StaffName.fromJson(json["name"]) : null,
  );

  Map<String, dynamic> toJson() => {"name": name?.toJson()};
}

class StaffName {
  final String? userPreferred;

  StaffName({this.userPreferred});

  factory StaffName.fromJson(Map<String, dynamic> json) =>
      StaffName(userPreferred: json["userPreferred"]);

  Map<String, dynamic> toJson() => {"userPreferred": userPreferred};
}

