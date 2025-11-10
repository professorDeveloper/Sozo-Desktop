// New file: characters_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sozodesktop/src/di/get_it.dart';
import 'package:sozodesktop/src/features/detail/bloc/character_event.dart';
import 'package:sozodesktop/src/features/detail/bloc/character_state.dart';
import 'package:sozodesktop/src/features/detail/model/character_model.dart';
import 'package:sozodesktop/src/features/detail/repository/detail_repository.dart';
import '../../../core/network/network_response.dart';


class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  final DetailRepository detailRepository = getIt<DetailRepository>();

  CharactersBloc() : super(CharactersInitial()) {
    on<FetchCharacters>(_onFetchCharacters);
  }

  Future<void> _onFetchCharacters(
      FetchCharacters event, Emitter<CharactersState> emit) async {
    emit(CharactersLoading());
    try {
      final response = await detailRepository.getCharacterById(event.mediaId);

      if (response.data != null && response.data is List<Character>) {
        emit(CharactersLoaded(response.data as List<Character>));
      } else {
        emit(CharactersError(response.errorText ?? 'Unknown error occurred'));
      }
    } catch (e) {
      emit(CharactersError('Failed to fetch characters: $e'));
    }
  }
}