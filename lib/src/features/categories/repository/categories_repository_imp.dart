import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../../home/model/home_anime_model.dart';
import 'categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final GraphQLClient client;

  CategoriesRepositoryImpl({required this.client});

  @override
  Future<List<HomeAnimeModel>> fetchAllAnime({required int page}) async {
    const String query = '''
      query getAllAnime(\$page: Int, \$perPage: Int) {
        Page(page: \$page, perPage: \$perPage) {
          media(sort: POPULARITY_DESC, type: ANIME, isAdult: false) {
            id
            format
            episodes
            genres
            season
            seasonYear
            title {
              english
            }
            coverImage {
              large
              medium
              extraLarge
            }
            bannerImage
            description
          }
        }
      }
    ''';

    try {
      final result = await client
          .query(
            QueryOptions(
              document: gql(query),
              variables: {'page': page, 'perPage': 20},
              fetchPolicy: FetchPolicy.networkOnly,
            ),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Request timed out. Please check your internet connection and try again.',
              );
            },
          );

      if (result.hasException) {
        if (result.exception?.linkException != null) {
          throw Exception(
            'Network error. Please check your internet connection.',
          );
        }
        throw Exception(result.exception.toString());
      }

      final List<dynamic> mediaList = result.data?['Page']?['media'] ?? [];
      return mediaList.map((json) => HomeAnimeModel.fromJson(json)).toList();
    } on TimeoutException {
      throw Exception(
        'Request timed out. Please check your internet connection and try again.',
      );
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Request timed out. Please try again or check your connection.',
        );
      }
      throw Exception('Failed to fetch anime: $e');
    }
  }

  @override
  Future<List<String>> fetchGenres() async {
    const String query = '''{ GenreCollection }''';

    try {
      final result = await client
          .query(
            QueryOptions(
              document: gql(query),
              fetchPolicy: FetchPolicy.networkOnly,
            ),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timed out. Please try again.');
            },
          );

      if (result.hasException) {
        if (result.exception?.linkException != null) {
          throw Exception(
            'Network error. Please check your internet connection.',
          );
        }
        throw Exception(result.exception.toString());
      }

      final List<dynamic> genres = result.data?['GenreCollection'] ?? [];
      return genres.cast<String>();
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Failed to fetch genres: $e');
    }
  }

  @override
  Future<List<HomeAnimeModel>> fetchAnimeByGenre({
    required String genre,
    required int page,
  }) async {
    const String query = '''
      query getAnimeByGenre(\$genre: String, \$page: Int, \$perPage: Int) {
        Page(page: \$page, perPage: \$perPage) {
          media(genre: \$genre, sort: POPULARITY_DESC, type: ANIME, isAdult: false) {
            id
            format
            episodes
            genres
            season
            seasonYear
            title {
              english
            }
            coverImage {
              large
              medium
              extraLarge
            }
            bannerImage
            description
          }
        }
      }
    ''';

    try {
      final result = await client
          .query(
            QueryOptions(
              document: gql(query),
              variables: {'genre': genre, 'page': page, 'perPage': 20},
              fetchPolicy: FetchPolicy.networkOnly,
            ),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception(
                'Request timed out. Please check your internet connection and try again.',
              );
            },
          );

      if (result.hasException) {
        // Handle specific exception types
        if (result.exception?.linkException != null) {
          throw Exception(
            'Network error. Please check your internet connection.',
          );
        }
        throw Exception(result.exception.toString());
      }

      final List<dynamic> mediaList = result.data?['Page']?['media'] ?? [];

      if (mediaList.isEmpty) {
        // Return empty list instead of throwing error
        return [];
      }

      return mediaList.map((json) => HomeAnimeModel.fromJson(json)).toList();
    } on TimeoutException {
      throw Exception(
        'Request timed out. The genre "$genre" is taking too long to load. Please try again.',
      );
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Request timed out for genre "$genre". Please try again or select a different genre.',
        );
      }
      throw Exception('Failed to fetch anime by genre: $e');
    }
  }
}
