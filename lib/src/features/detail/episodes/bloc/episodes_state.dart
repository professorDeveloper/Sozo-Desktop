// lib/bloc/episode/episode_state.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
abstract class EpisodeState extends Equatable {
  const EpisodeState();
  @override
  List<Object?> get props => [];
}

class EpisodeInitial extends EpisodeState {}

class EpisodeLoading extends EpisodeState {}

class EpisodeLoaded extends EpisodeState {
  final List<String> seasons;                     // ["1-Mavsum", …]
  final List<List<Map<String, String>>> episodes; // real data
  const EpisodeLoaded(this.seasons, this.episodes);
  @override
  List<Object?> get props => [seasons, episodes];
}

class EpisodeError extends EpisodeState {
  final String message;
  const EpisodeError(this.message);
  @override
  List<Object?> get props => [message];
}