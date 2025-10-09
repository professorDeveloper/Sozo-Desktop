import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLClientManager {
  static GraphQLClient? _instance;

  // Private constructor to prevent instantiation
  GraphQLClientManager._();

  static GraphQLClient getInstance() {
    if (_instance == null) {
      final httpLink = HttpLink(
        'https://graphql.anilist.co',
      );

      // Add authentication link if needed in future
      final authLink = AuthLink(
        getToken: () async => '',
      );

      final link = authLink.concat(httpLink);

      _instance = GraphQLClient(
        cache: GraphQLCache(store: InMemoryStore()),
        link: link,
        defaultPolicies: DefaultPolicies(
          query: Policies(
            fetch: FetchPolicy.networkOnly,
            error: ErrorPolicy.all,
            cacheReread: CacheRereadPolicy.mergeOptimistic,
          ),
        ),
      );
    }
    return _instance!;
  }

  // Method to reset client if needed
  static void resetClient() {
    _instance = null;
  }
}