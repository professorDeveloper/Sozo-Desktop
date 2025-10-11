part of 'channel_bloc.dart';

abstract class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends ChannelEvent {
  const LoadCategories();
}

class LoadCountries extends ChannelEvent {
  const LoadCountries();
}

class LoadChannelsForCountry extends ChannelEvent {
  final String countryCode;

  const LoadChannelsForCountry(this.countryCode);

  @override
  List<Object> get props => [countryCode];
}

class LoadChannelsForCategory extends ChannelEvent {
  final String categoryKey;

  const LoadChannelsForCategory(this.categoryKey);

  @override
  List<Object> get props => [categoryKey];
}