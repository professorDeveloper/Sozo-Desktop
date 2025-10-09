part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class FetchBanners extends HomeEvent {}
final class FetchTrending extends HomeEvent {}
final class FetchMostFavourite extends HomeEvent {}
