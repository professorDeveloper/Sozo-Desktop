import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sozodesktop/src/features/search/bloc/search_event.dart';
import '../../../di/get_it.dart' as di;
import '../../home/model/home_anime_model.dart';
import '../repository/search_repository.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  SearchBloc() : super(SearchInitial()) {
    on<PerformSearch>(_onPerformSearch);
    on<ClearSearch>(_onClearSearch);
  }
  final SearchRepository repository = di.getIt<SearchRepository>();

  Future<void> _onPerformSearch(PerformSearch event, Emitter<SearchState> emit) async {
    if (event.query.isEmpty) {
      emit(SearchEmpty());
      return;
    }

    emit(SearchLoading());

    final response = await repository.searchAnime(event.query);

    if (response.errorText.isNotEmpty) {
      emit(SearchError(response.errorText));
      return;
    }

    final results = response.data ?? [];
    if (results.isEmpty) {
      emit(SearchEmpty());
    } else {
      emit(SearchLoaded(results));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchEmpty());
  }
}