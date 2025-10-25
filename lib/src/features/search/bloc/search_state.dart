part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchTrendingLoading extends SearchState {
  final List<HomeAnimeModel> previousResults;

  SearchTrendingLoading(this.previousResults);
}
class SearchLoaded extends SearchState {
  final List<HomeAnimeModel> results;

  SearchLoaded(this.results);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

class SearchEmpty extends SearchState {}