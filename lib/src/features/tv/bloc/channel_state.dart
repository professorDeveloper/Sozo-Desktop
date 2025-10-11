part of 'channel_bloc.dart';

enum ChannelStatus { initial, loading, success, failure }

class ChannelState extends Equatable {
  final ChannelStatus status;
  final List<Category> categories;
  final List<Country> countries;
  final List<Channel> channels;
  final String? errorMessage;

  const ChannelState({
    required this.status,
    this.categories = const [],
    this.countries = const [],
    this.channels = const [],
    this.errorMessage,
  });

  const ChannelState.initial()
      : status = ChannelStatus.initial,
        categories = const [],
        countries = const [],
        channels = const [],
        errorMessage = null;

  ChannelState copyWith({
    ChannelStatus? status,
    List<Category>? categories,
    List<Country>? countries,
    List<Channel>? channels,
    String? errorMessage,
  }) {
    return ChannelState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      countries: countries ?? this.countries,
      channels: channels ?? this.channels,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        countries,
        channels,
        errorMessage,
      ];
}