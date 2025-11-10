// New file: characters_event.dart
import 'package:meta/meta.dart';
@immutable
sealed class CharactersEvent {}

class FetchCharacters extends CharactersEvent {
  final int mediaId;

  FetchCharacters(this.mediaId);
}