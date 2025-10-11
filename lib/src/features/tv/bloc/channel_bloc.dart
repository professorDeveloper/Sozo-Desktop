import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../utils/itv_garden_manager.dart';
import '../repository/channel_repository.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final ChannelRepository _repository;

  ChannelBloc({required ChannelRepository repository})
      : _repository = repository,
        super(const ChannelState.initial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadCountries>(_onLoadCountries);
    on<LoadChannelsForCountry>(_onLoadChannelsForCountry);
    on<LoadChannelsForCategory>(_onLoadChannelsForCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ChannelState> emit,
  ) async {
    emit(state.copyWith(status: ChannelStatus.loading));
    try {
      final categories = await _repository.getCategories();
      emit(state.copyWith(
        status: ChannelStatus.success,
        categories: categories,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChannelStatus.failure,
        errorMessage: 'Failed to load categories: $e',
      ));
    }
  }

  Future<void> _onLoadCountries(
    LoadCountries event,
    Emitter<ChannelState> emit,
  ) async {
    emit(state.copyWith(status: ChannelStatus.loading));
    try {
      final countries = await _repository.getCountries();
      emit(state.copyWith(
        status: ChannelStatus.success,
        countries: countries,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChannelStatus.failure,
        errorMessage: 'Failed to load countries: $e',
      ));
    }
  }

  Future<void> _onLoadChannelsForCountry(
    LoadChannelsForCountry event,
    Emitter<ChannelState> emit,
  ) async {
    emit(state.copyWith(status: ChannelStatus.loading));
    try {
      final channels = await _repository.getChannelsForCountry(event.countryCode);
      emit(state.copyWith(
        status: ChannelStatus.success,
        channels: channels,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChannelStatus.failure,
        errorMessage: 'Failed to load channels for country ${event.countryCode}: $e',
      ));
    }
  }

  Future<void> _onLoadChannelsForCategory(
    LoadChannelsForCategory event,
    Emitter<ChannelState> emit,
  ) async {
    emit(state.copyWith(status: ChannelStatus.loading));
    try {
      final channels = await _repository.getChannelsForCategory(event.categoryKey);
      emit(state.copyWith(
        status: ChannelStatus.success,
        channels: channels,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ChannelStatus.failure,
        errorMessage: 'Failed to load channels for category ${event.categoryKey}: $e',
      ));
    }
  }
}