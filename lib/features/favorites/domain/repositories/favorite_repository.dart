import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteEntity>> addToFavorites(String plantId);
  Future<List<FavoriteEntity>> getFavorites();
  Future<List<FavoriteEntity>> removeFromFavorites(String plantId);
  Future<bool> checkIsFavorite(String plantId);
}
