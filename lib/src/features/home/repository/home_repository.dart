import '../../../core/network/network_response.dart';

abstract class HomeRepository {
  Future<NetworkResponse> getBanners();
  Future<NetworkResponse> getTrending();
  Future<NetworkResponse> getMostFavourite();
  Future<NetworkResponse> getReccommended();

}