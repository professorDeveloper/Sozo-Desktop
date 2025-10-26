part of 'detail_bloc.dart';

@immutable
sealed class DetailEvent {}

class FetchAnimeDetails extends DetailEvent {
  final int animeId;

  FetchAnimeDetails(this.animeId);
}