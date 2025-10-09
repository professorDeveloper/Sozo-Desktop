import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sozodesktop/src/core/graphql/client.dart';
import 'package:sozodesktop/src/features/search/bloc/search_bloc.dart';
import 'package:sozodesktop/src/features/search/repository/search_repository.dart';
import 'package:sozodesktop/src/features/search/repository/search_repository_imp.dart';

import '../features/home/bloc/home_bloc.dart';
import '../features/home/repository/home_repository.dart';
import '../features/home/repository/home_repository_imp.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<GraphQLClient>(
    () => GraphQLClientManager.getInstance(),
  );
  // Register other dependencies here, e.g., repositories, blocs, etc.
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImp(getIt<GraphQLClient>()),
  );
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImp(getIt<GraphQLClient>()),
  );
  getIt.registerLazySingleton<SearchBloc>(() => SearchBloc());
  getIt.registerLazySingleton<HomeBloc>(() => HomeBloc());
}
