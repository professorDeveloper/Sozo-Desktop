import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sozodesktop/src/features/home/model/home_anime_model.dart';
import 'package:sozodesktop/src/features/home/repository/home_repository.dart';
import '../../../di/get_it.dart' as di;
import '../model/banner_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository = di.getIt<HomeRepository>();

  HomeBloc() : super(HomeInitial()) {
    on<FetchBanners>((event, emit) async {
      emit(HomeLoading());
      try {
        final responses = await Future.wait([
          _repository.getBanners(),
          _repository.getTrending(),
          _repository.getMostFavourite(),
          _repository.getReccommended(),
        ]);

        final bannerResponse = responses[0];
        final trendingResponse = responses[1];
        final mostFavouriteResponse = responses[2];
        final reccommendedResponse = responses[3];

        // Xatolarni tekshirish

        // Ma'lumotlarni xavfsiz kasting qilish
        final banners = bannerResponse.data as List<BannerDataModel>? ?? [];
        final trending = trendingResponse.data as List<HomeAnimeModel>? ?? [];
        final mostFavourite = mostFavouriteResponse.data as List<HomeAnimeModel>? ?? [];
        final reccommended = reccommendedResponse.data as List<HomeAnimeModel>? ?? [];

        emit(HomeLoaded(
          banners: banners,
          reccommended: reccommended,
          trending: trending,
          mostFavourite: mostFavourite,
        ));
      } catch (e) {
        emit(HomeError(message: 'Noma’lum xato yuz berdi: $e'));
      }
    });
  }
}