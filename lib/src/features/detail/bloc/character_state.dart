// New file: characters_state.dart
import 'package:meta/meta.dart';

import '../model/character_model.dart';
@immutable
sealed class CharactersState {}

class CharactersInitial extends CharactersState {}

class CharactersLoading extends CharactersState {}

class CharactersLoaded extends CharactersState {
  final List<Character> characters;

  CharactersLoaded(this.characters);
}

class CharactersError extends CharactersState {
  final String errorMessage;

  CharactersError(this.errorMessage);
}