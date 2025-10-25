import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sozodesktop/src/features/home/model/home_anime_model.dart';

// Events
@immutable
sealed class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTrendingAnime extends SearchEvent {

}

class PerformSearch extends SearchEvent {
  final String query;

  PerformSearch(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends SearchEvent {}

// States
@immutable
sealed class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<HomeAnimeModel> results;

  SearchLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchEmpty extends SearchState {}