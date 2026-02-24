import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/core/api/api_client.dart';
import 'package:nurser_e/core/api/api_endpoints.dart';
import 'package:nurser_e/features/favorites/data/datasources/favorite_datasource.dart';
import 'package:nurser_e/features/favorites/data/models/favorite_api_model.dart';

final favoriteRemoteDatasourceProvder = Provider<IFavoritesRemoteDatasource>((
  ref,
) {
  return FavoriteRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class FavoriteRemoteDatasource implements IFavoritesRemoteDatasource {
  final ApiClient _apiClient;

  FavoriteRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;
  @override
  Future<FavoriteApiModel> addToFavorites(String plantId) async {
    final response = await _apiClient.post(
      ApiEndpoints.favorites,
      data: {'plantId': plantId},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      return FavoriteApiModel.fromJson(data);
    }
    return FavoriteApiModel(plants: []);
  }

  @override
  Future<bool> checkIsFavorite(String plantId) async {
    final response = await _apiClient.get('${ApiEndpoints.favorites}/$plantId');

    if (response.data['success'] == true) {
      final isFavorited = response.data['data']?['isFavorited'] as bool?;
      return isFavorited ?? false;
    }
    return false;
  }

  @override
  Future<FavoriteApiModel> getFavorites() async {
    final response = await _apiClient.get(ApiEndpoints.favorites);

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>?;
      if (data == null) {
        return FavoriteApiModel(plants: []);
      }
      return FavoriteApiModel.fromJson(data);
    }
    return FavoriteApiModel(plants: []);
  }

  @override
  Future<FavoriteApiModel> removeFromFavorites(String plantId) async {
    final response = await _apiClient.delete(
      '${ApiEndpoints.favorites}/$plantId',
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>?;
      return FavoriteApiModel.fromJson(data ?? {});
    }
    return FavoriteApiModel(plants: []);
  }
}
