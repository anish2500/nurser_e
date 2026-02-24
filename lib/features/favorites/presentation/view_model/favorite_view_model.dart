import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nurser_e/features/favorites/data/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/presentation/state/favorite_state.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';

final favoritesViewModelProvider =
    NotifierProvider<FavoritesViewModel, FavoriteState>(
      () => FavoritesViewModel(),
    );

class FavoritesViewModel extends Notifier<FavoriteState> {
  late final FavoriteRepository _repository;
  @override
  FavoriteState build() {
    _repository = ref.read(favoritesRepositoryProvider);
    return FavoriteState.initial();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(status: FavoriteStatus.loading);
    try {
      final favorites = await _repository.getFavorites();
      state = state.copyWith(
        status: FavoriteStatus.loaded,
        favorites: favorites,
      );
    } catch (e) {
      state = state.copyWith(
        status: FavoriteStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> addToFavorites(PlantEntity plant) async {
    try {
      final favorites = await _repository.addToFavorites(plant.id);
      state = state.copyWith(
        status: FavoriteStatus.loaded,
        favorites: favorites,
      );
    } catch (e) {
      state = state.copyWith(
        status: FavoriteStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> removeFromFavorites(String plantId) async {
    try {
      final favorites = await _repository.removeFromFavorites(plantId);
      state = state.copyWith(
        status: FavoriteStatus.loaded,
        favorites: favorites,
      );
    } catch (e) {
      state = state.copyWith(
        status: FavoriteStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> toggleFavorite(PlantEntity plant) async {
    final isFav = await _repository.checkIsFavorite(plant.id);
    if (isFav) {
      final updatedList = state.favorites
          .where((fav) => fav.plantId != plant.id)
          .toList();
      state = state.copyWith(
        favorites: updatedList,
        status: FavoriteStatus.loaded,
      );

      try {
        await _repository.removeFromFavorites(plant.id);
      } catch (e) {
        await loadFavorites();
      }
    } else {
      final tempFavorite = FavoriteEntity(
        id: plant.id,
        plantId: plant.id,
        name: plant.name,
        category: plant.category,
        description: plant.description,
        price: plant.price,
        plantImages: plant.plantImages,
        stock: plant.stock,
      );

      final updatedList = [...state.favorites, tempFavorite];
      state = state.copyWith(
        favorites: updatedList,
        status: FavoriteStatus.loaded,
      );

      try {
        await _repository.addToFavorites(plant.id);
      } catch (e) {
        // If API fails, revert
        await loadFavorites();
      }
    }
  }

  bool isFavorite(String plantId) {
    return state.favorites.any((fav) => fav.plantId == plantId);
  }
}
