import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:meta/meta.dart';
import '../../../core/graphql/querys.dart';
import '../../../core/network/network_response.dart';
import '../../home/model/home_anime_model.dart';
import 'search_repository.dart';

@immutable
class SearchRepositoryImp implements SearchRepository {
  final GraphQLClient client;

  const SearchRepositoryImp(this.client);

  @override
  Future<NetworkResponse<List<HomeAnimeModel>>> searchAnime(String query) async {
    // Validate query
    if (query.trim().isEmpty) {
      return NetworkResponse(
        data: [],
        errorText: '',
      );
    }

    try {
      final result = await client.query(
        QueryOptions(
          document: gql(searchQuery),
          variables: {'search': query.trim()},
          fetchPolicy: FetchPolicy.networkOnly, // Always fetch fresh results
        ),
      );

      // Check for GraphQL errors
      if (result.hasException) {
        final exception = result.exception;
        String errorMessage = 'An error occurred';

        if (exception?.graphqlErrors.isNotEmpty ?? false) {
          errorMessage = exception!.graphqlErrors.first.message;
        } else if (exception?.linkException != null) {
          errorMessage = 'Network error. Please check your connection.';
        }

        return NetworkResponse(errorText: errorMessage);
      }

      // Check if data exists
      if (result.data == null) {
        return NetworkResponse(errorText: 'No data received');
      }

      final mediaList = result.data?['Page']?['media'] as List<dynamic>? ?? [];

      // Handle empty results
      if (mediaList.isEmpty) {
        return NetworkResponse(data: []);
      }

      // Map to models with proper null handling
      final animeList = mediaList.map((json) {
        try {
          // Handle title fallback
          final titleJson = json['title'] as Map<String, dynamic>?;
          if (titleJson != null) {
            final englishTitle = titleJson['english'] as String?;
            final romajiTitle = titleJson['romaji'] as String?;
            final nativeTitle = titleJson['native'] as String?;

            json['title'] = {
              'english': englishTitle ?? romajiTitle ?? nativeTitle ?? 'Unknown',
            };
          }

          return HomeAnimeModel.fromJson(json);
        } catch (e) {
          // Log individual parsing errors but continue
          print('Error parsing anime item: $e');
          return null;
        }
      }).whereType<HomeAnimeModel>().toList();

      return NetworkResponse(data: animeList);
    } on FormatException catch (e) {
      return NetworkResponse(errorText: 'Invalid data format: ${e.message}');
    } on TypeError catch (e) {
      return NetworkResponse(errorText: 'Data parsing error: $e');
    } catch (e) {
      return NetworkResponse(errorText: 'Unexpected error: ${e.toString()}');
    }
  }
}