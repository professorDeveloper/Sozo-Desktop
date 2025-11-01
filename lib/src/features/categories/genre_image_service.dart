import 'dart:async';
import 'dart:math';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/graphql/client.dart';

class GenreImageService {
  static final Map<String, List<String>> _cache = {};
  static final Map<String, DateTime> _lastFetch = {};
  static const Duration _rateLimitWindow = Duration(minutes: 1);
  static const int _maxRequestsPerWindow = 90;
  static int _requestCount = 0;
  static DateTime _windowStart = DateTime.now();

  static final Random _random = Random();

  static Future<String?> fetchGenreImage(String genre) async {
    if (_cache.containsKey(genre) && _cache[genre]!.isNotEmpty) {
      return _cache[genre]![_random.nextInt(_cache[genre]!.length)];
    }

    final now = DateTime.now();
    if (now.difference(_windowStart) >= _rateLimitWindow) {
      _requestCount = 0;
      _windowStart = now;
    } else if (_requestCount >= _maxRequestsPerWindow) {
      final delay = _rateLimitWindow - now.difference(_windowStart);
      await Future.delayed(delay);
      _requestCount = 0;
      _windowStart = DateTime.now();
    }

    if (_lastFetch.containsKey(genre)) {
      final timeSinceLastFetch = now.difference(_lastFetch[genre]!);
      if (timeSinceLastFetch < const Duration(minutes: 5)) {
        return _cache[genre]?.isNotEmpty == true
            ? _cache[genre]![_random.nextInt(_cache[genre]!.length)]
            : null;
      }
    }

    final client = GraphQLClientManager.getInstance();

    const String query = r'''
    query getTopByGenre($genre: String) {
      Page(page: 1, perPage: 10) {
        media(genre_in: [$genre], sort: POPULARITY_DESC, type: ANIME, isAdult: false) {
          coverImage { large medium extraLarge }
        }
      }
    }
    ''';

    try {
      _requestCount++;
      _lastFetch[genre] = DateTime.now();

      final options = QueryOptions(
        document: gql(query),
        variables: {'genre': genre},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await client.query(options);
      final media = result.data?['Page']?['media'] as List?;

      if (media == null || media.isEmpty) {
        return null;
      }

      final urls = <String>[];
      for (final item in media) {
        final coverImage = item['coverImage'];
        if (coverImage != null) {
          // Try each image size in order of preference
          String? url = coverImage['extraLarge'] as String?;
          url ??= coverImage['large'] as String?;
          url ??= coverImage['medium'] as String?;

          if (url != null &&
              url.isNotEmpty &&
              Uri.tryParse(url)?.hasAbsolutePath == true) {
            print('Found valid image URL for $genre: $url');
            urls.add(url);
          }
        }
      }

      print('Retrieved ${urls.length} images for genre: $genre');

      if (urls.isEmpty) {
        return null;
      }

      _cache[genre] = urls;
      return urls[_random.nextInt(urls.length)];
    } catch (e) {
      print('Error fetching genre image for $genre: $e');
      return null;
    }
  }

  static Future<Map<String, String?>> prefetchGenres(
    List<String> genres,
  ) async {
    final futures = <Future<String?>>[];
    for (final g in genres) {
      if (_cache.containsKey(g) && _cache[g]!.isNotEmpty) {
        futures.add(
          Future.value(_cache[g]![_random.nextInt(_cache[g]!.length)]),
        );
      } else {
        futures.add(fetchGenreImage(g));
      }
    }

    final results = await Future.wait(futures);
    final Map<String, String?> map = {};

    for (var i = 0; i < genres.length; i++) {
      map[genres[i]] = results[i];
    }

    final used = <String>{};
    for (var genre in genres) {
      final url = map[genre];
      if (url != null && url.isNotEmpty) {
        if (used.contains(url) && _cache[genre]?.isNotEmpty == true) {
          final unused = _cache[genre]!
              .where((u) => !used.contains(u))
              .toList();
          if (unused.isNotEmpty) {
            map[genre] = unused[_random.nextInt(unused.length)];
            used.add(map[genre]!);
          } else {
            map[genre] = null;
          }
        } else {
          used.add(url);
        }
      }
    }

    return map;
  }
}
