import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sozodesktop/src/di/get_it.dart';
import 'package:sozodesktop/src/features/detail/repository/detail_repository.dart';

import '../../../core/model/responses/media.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final DetailRepository detailRepository = getIt<DetailRepository>();
  DetailBloc() : super(AboutInitial()) {
    on<FetchAnimeDetails>(_onFetchAnimeDetails);
  }

  Future<void> _onFetchAnimeDetails(
      FetchAnimeDetails event, Emitter<DetailState> emit) async {
    emit(AboutLoading());
    try {
      final response = await detailRepository.getAnimeByID(event.animeId);
      if (response.data != null) {
        emit(AboutLoaded(response.data as Media));
      } else {
        emit(AboutError(response.errorText ?? 'Unknown error occurred'));
      }
    } catch (e) {
      emit(AboutError('Failed to fetch anime details: $e'));
    }
  }
}