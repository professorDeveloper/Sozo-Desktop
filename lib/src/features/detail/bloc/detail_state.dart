part of 'detail_bloc.dart';

@immutable
sealed class DetailState {}

class AboutInitial extends DetailState {}

class AboutLoading extends DetailState {}

class AboutLoaded extends DetailState {
  final Media anime;

  AboutLoaded(this.anime);
}

class AboutError extends DetailState {
  final String errorMessage;

  AboutError(this.errorMessage);
}
