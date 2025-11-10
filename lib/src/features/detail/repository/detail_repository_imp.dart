import 'package:flutter/src/painting/image_provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sozodesktop/src/core/model/responses/media.dart';
import 'package:sozodesktop/src/features/detail/model/relations_model.dart';
import 'package:sozodesktop/src/features/home/model/home_anime_model.dart';
import '../../../core/graphql/querys.dart';
import '../../../core/network/network_response.dart';
import '../model/character_model.dart';
import 'detail_repository.dart';

class DetailRepositoryImp implements DetailRepository {
  final GraphQLClient _client;

  DetailRepositoryImp(this._client);

  @override
  Future<NetworkResponse> getAnimeByID(int id) async {
    try {
      final result = await _client.query(
        QueryOptions(document: gql(getAnimeByIdQuery), variables: {'id': id}),
      );

      if (result.hasException) {
        return NetworkResponse(
          errorText: result.exception?.graphqlErrors.isNotEmpty == true
              ? result.exception!.graphqlErrors.first.message
              : 'Unknown error occurred',
        );
      }

      final data = result.data?['Media'];
      if (data == null) {
        return NetworkResponse(errorText: 'No data found for ID $id');
      }

      final anime = Media.fromJson(data as Map<String, dynamic>);

      return NetworkResponse(data: anime);
    } catch (e) {
      return NetworkResponse(errorText: 'An unexpected error occurred: $e');
    }
  }

  @override
  Future<NetworkResponse> getCharacterById(int id) async {
    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(getCharactersAnimeByIdQuery),
          variables: {'id': id},
        ),
      );


      final rawNodes = result.data?['Media']?['characters']?['nodes'] as List?;
      if (rawNodes == null || rawNodes.isEmpty) {
        return NetworkResponse(data: <Character>[]);
      }

      final characters = rawNodes
          .cast<Map<String, dynamic>>()
          .map(Character.fromJson)
          .toList();

      return NetworkResponse(data: characters);
    } catch (e) {
      return NetworkResponse(errorText: 'Unexpected error: $e');
    }
  }
}
