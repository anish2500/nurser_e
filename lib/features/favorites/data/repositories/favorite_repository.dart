import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/favorites/data/datasources/favorite_datasource.dart';
import 'package:nurser_e/features/favorites/data/datasources/remote/favorite_remote_datasource.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';

final favoritesRepositoryProvider = Provider<FavoriteRepositoryImpl>((ref) {
  return FavoriteRepositoryImpl(
    remoteDatasource: ref.read(favoriteRemoteDatasourceProvder),
  );
});

class FavoriteRepositoryImpl implements FavoriteRepository {
  final IFavoritesRemoteDatasource remoteDatasource;
  FavoriteRepositoryImpl({required this.remoteDatasource});
  @override
  Future<List<FavoriteEntity>> addToFavorites(String plantId) async {
    final model = await remoteDatasource.addToFavorites(plantId);
    return model.toEntityList();
  }

  @override
  Future<bool> checkIsFavorite(String plantId) async {
    return await remoteDatasource.checkIsFavorite(plantId);
  }

  @override
  Future<List<FavoriteEntity>> getFavorites() async {
    final model = await remoteDatasource.getFavorites();
    return model.toEntityList();
  }

  @override
  Future<List<FavoriteEntity>> removeFromFavorites(String plantId) async {
    final model = await remoteDatasource.removeFromFavorites(plantId);
    return model.toEntityList();
  }
}
