import 'package:nurser_e/features/favorites/data/models/favorite_api_model.dart';

abstract interface class IFavoritesRemoteDatasource {
  Future<FavoriteApiModel> getFavorites();
  Future<FavoriteApiModel> addToFavorites(String plantId);
  Future<FavoriteApiModel> removeFromFavorites(String plantId);
  Future<bool> checkIsFavorite(String plantId);
}
