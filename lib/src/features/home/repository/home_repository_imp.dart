import 'package:sozodesktop/src/features/home/model/banner_model.dart';
import '../../../core/graphql/querys.dart';
import '../../../core/network/network_response.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../model/home_anime_model.dart';
import 'home_repository.dart';

class HomeRepositoryImp implements HomeRepository {
  final GraphQLClient _client;

  HomeRepositoryImp(this._client);

  @override
  Future<NetworkResponse<List<BannerDataModel>>> getBanners({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(bannerQuery),
        ),
      );
      print("Banners Data: ${result.data}");

      if (result.hasException) {
        print(result.exception?.graphqlErrors);

        return NetworkResponse(
          errorText: result.exception?.graphqlErrors.isNotEmpty == true
              ? result.exception!.graphqlErrors.first.message
              : 'Unknown error occurred',
        );
      }

      final data = result.data;
      if (data == null ||
          data['Page'] == null ||
          data['Page']['media'] == null) {
        return NetworkResponse(errorText: 'No data available');
      }

      final List<dynamic> mediaList = data['Page']['media'];
      return NetworkResponse(
        data: mediaList
            .map(
              (item) => BannerDataModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      return NetworkResponse(errorText: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<NetworkResponse> getMostFavourite() async {
    try {
      final result = await _client.query(
        QueryOptions(document: gql(mostFavouriteQuery)),
      );
      print(result.data);

      if (result.hasException) {
        print(result.exception?.graphqlErrors);

        return NetworkResponse(
          errorText: result.exception?.graphqlErrors.isNotEmpty == true
              ? result.exception!.graphqlErrors.first.message
              : 'Unknown error occurred',
        );
      }

      final data = result.data;
      if (data == null ||
          data['Page'] == null ||
          data['Page']['media'] == null) {
        return NetworkResponse(errorText: 'No data available');
      }

      final List<dynamic> mediaList = data['Page']['media'];
      return NetworkResponse(
        data: mediaList
            .map(
              (item) => HomeAnimeModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      return NetworkResponse(errorText: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<NetworkResponse> getTrending() async {
    try {
      final result = await _client.query(
        QueryOptions(document: gql(trendingQuery)),
      );
      print(result.data);

      if (result.hasException) {
        print(result.exception?.graphqlErrors);

        return NetworkResponse(
          errorText: result.exception?.graphqlErrors.isNotEmpty == true
              ? result.exception!.graphqlErrors.first.message
              : 'Unknown error occurred',
        );
      }

      final data = result.data;
      if (data == null ||
          data['Page'] == null ||
          data['Page']['media'] == null) {
        return NetworkResponse(errorText: 'No data available');
      }

      final List<dynamic> mediaList = data['Page']['media'];
      return NetworkResponse(
        data: mediaList
            .map(
              (item) => HomeAnimeModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      return NetworkResponse(errorText: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<NetworkResponse> getReccommended()async {
    try {
      final result = await _client.query(
        QueryOptions(document: gql(reccomendationQuery)),
      );
      print(result.data);

      if (result.hasException) {
        print(result.exception?.graphqlErrors);

        return NetworkResponse(
          errorText: result.exception?.graphqlErrors.isNotEmpty == true
              ? result.exception!.graphqlErrors.first.message
              : 'Unknown error occurred',
        );
      }

      final data = result.data;
      if (data == null ||
          data['Page'] == null ||
          data['Page']['media'] == null) {
        return NetworkResponse(errorText: 'No data available');
      }

      final List<dynamic> mediaList = data['Page']['media'];
      return NetworkResponse(
        data: mediaList
            .map(
              (item) => HomeAnimeModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
    } catch (e) {
      return NetworkResponse(errorText: 'An unexpected error occurred: $e');
    }

  }
}
