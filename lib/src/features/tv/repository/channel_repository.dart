
import '../../../utils/itv_garden_manager.dart';

class ChannelRepository {

  Future<List<Category>> getCategories() async {
    return await GardenDataManager.loadCategoriesFromApi();
  }

  Future<List<Country>> getCountries() async {
    return await GardenDataManager.loadCountriesFromApi();
  }

  Future<List<Channel>> getChannelsForCountry(String countryCode) async {
    return await GardenDataManager.loadChannelsForCountry(countryCode);
  }

  Future<List<Channel>> getChannelsForCategory(String categoryKey) async {
    return await GardenDataManager.loadChannelsForCategory(categoryKey);
  }
}