// lib/src/features/detail/model/character_model.dart

class CharacterResponse {
  final List<Character> characters;

  CharacterResponse({required this.characters});

  factory CharacterResponse.fromJson(Map<String, dynamic> json) {
    final nodes = json['data']['Media']['characters']['nodes'] as List;
    return CharacterResponse(
      characters: nodes.map((e) => Character.fromJson(e)).toList(),
    );
  }
}

class Character {
  final int id;
  final String name;     // userPreferred
  final String? middleName;
  final String? age;
  final String? imageUrl;

  Character({
    required this.id,
    required this.name,
    this.middleName,
    this.age,
    this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final nameMap = json['name'] as Map<String, dynamic>;
    return Character(
      id: json['id'] as int,
      name: nameMap['userPreferred'] as String,
      middleName: nameMap['middle'],
      age: json['age'] as String?,
      imageUrl: (json['image'] as Map<String, dynamic>?)?['medium'] as String?,
    );
  }

  @override
  String toString() => 'Character(id: $id, name: $name, age: $age)';
}