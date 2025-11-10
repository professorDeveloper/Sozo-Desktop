// lib/bloc/episode/episode_event.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
abstract class EpisodeEvent extends Equatable {
  const EpisodeEvent();
  @override
  List<Object> get props => [];
}

class LoadEpisodes extends EpisodeEvent {
  final String query;          // anime.title.english
  const LoadEpisodes(this.query);
  @override
  List<Object> get props => [query];
}