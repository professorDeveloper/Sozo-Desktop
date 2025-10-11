import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sozodesktop/src/core/graphql/client.dart';
import 'package:sozodesktop/src/features/search/bloc/search_bloc.dart';
import 'package:sozodesktop/src/features/search/repository/search_repository.dart';
import 'package:sozodesktop/src/features/search/repository/search_repository_imp.dart';
import 'package:sozodesktop/src/features/home/bloc/home_bloc.dart';
import 'package:sozodesktop/src/features/home/repository/home_repository.dart';
import 'package:sozodesktop/src/features/home/repository/home_repository_imp.dart';
import 'package:sozodesktop/src/features/tv/repository/channel_repository.dart';

import '../features/tv/bloc/channel_bloc.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  // Register GraphQLClient
  getIt.registerLazySingleton<GraphQLClient>(
        () => GraphQLClientManager.getInstance(),
  );

  // Register Repositories
  getIt.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImp(getIt<GraphQLClient>()),
  );
  getIt.registerLazySingleton<SearchRepository>(
        () => SearchRepositoryImp(getIt<GraphQLClient>()),
  );
  getIt.registerLazySingleton<ChannelRepository>(
        () => ChannelRepository(),
  );

  // Register Blocs
  getIt.registerLazySingleton<SearchBloc>(() => SearchBloc());
  getIt.registerLazySingleton<HomeBloc>(() => HomeBloc());
  getIt.registerLazySingleton<ChannelBloc>(
        () => ChannelBloc(repository: getIt<ChannelRepository>()),
  );
}