part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}


final class HomeLoaded extends HomeState {
  final List<BannerDataModel> banners;
  final List<HomeAnimeModel> trending ;
  final List<HomeAnimeModel> mostFavourite ;
  final List<HomeAnimeModel> reccommended ;
  HomeLoaded({required this.banners, required this.trending, required this.mostFavourite, required this.reccommended});
}

final class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});
}