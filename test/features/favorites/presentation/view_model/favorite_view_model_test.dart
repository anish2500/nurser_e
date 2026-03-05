import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/favorites/data/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/favorites/presentation/state/favorite_state.dart';
import 'package:nurser_e/features/favorites/presentation/view_model/favorite_view_model.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';

class MockFavoriteRepositoryImpl extends Mock implements FavoriteRepositoryImpl {}

void main() {
  late FavoritesViewModel viewModel;
  late MockFavoriteRepositoryImpl mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockFavoriteRepositoryImpl();
  });

  tearDown(() {
    container.dispose();
  });

  ProviderContainer createContainer() {
    container = ProviderContainer(
      overrides: [
        favoritesRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    return container;
  }

  final tFavorites = [
    FavoriteEntity(
      id: '1',
      plantId: '1',
      name: 'Rose Plant',
      category: 'Flowers',
      description: 'A beautiful rose',
      price: 25.99,
      plantImages: ['rose.jpg'],
      stock: 10,
    ),
  ];

  final tPlant = PlantEntity(
    id: '1',
    name: 'Rose Plant',
    description: 'A beautiful rose',
    category: 'Flowers',
    price: 25.99,
    plantImages: ['rose.jpg'],
    stock: 10,
  );

  group('loadFavorites', () {
    test('should update state to loaded with favorites', () async {
      when(() => mockRepository.getFavorites())
          .thenAnswer((_) async => tFavorites);

      createContainer();
      viewModel = container.read(favoritesViewModelProvider.notifier);
      
      await viewModel.loadFavorites();

      expect(viewModel.state.status, FavoriteStatus.loaded);
      expect(viewModel.state.favorites.length, 1);
    });

    test('should update state to error when exception occurs', () async {
      when(() => mockRepository.getFavorites())
          .thenThrow(Exception('Failed to load'));

      createContainer();
      viewModel = container.read(favoritesViewModelProvider.notifier);
      
      await viewModel.loadFavorites();

      expect(viewModel.state.status, FavoriteStatus.error);
    });
  });

  group('addToFavorites', () {
    test('should add plant to favorites', () async {
      when(() => mockRepository.addToFavorites(any()))
          .thenAnswer((_) async => tFavorites);

      createContainer();
      viewModel = container.read(favoritesViewModelProvider.notifier);
      
      await viewModel.addToFavorites(tPlant);

      expect(viewModel.state.status, FavoriteStatus.loaded);
    });
  });

  group('removeFromFavorites', () {
    test('should remove plant from favorites', () async {
      when(() => mockRepository.removeFromFavorites(any()))
          .thenAnswer((_) async => []);

      createContainer();
      viewModel = container.read(favoritesViewModelProvider.notifier);
      
      await viewModel.removeFromFavorites('1');

      expect(viewModel.state.status, FavoriteStatus.loaded);
    });
  });

  group('isFavorite', () {
    test('should return true when plant is favorite', () {
      createContainer();
      viewModel = container.read(favoritesViewModelProvider.notifier);
      viewModel.state = FavoriteState(
        status: FavoriteStatus.loaded,
        favorites: tFavorites,
      );

      final result = viewModel.isFavorite('1');

      expect(result, true);
    });

    test('should return false when plant is not favorite', () {
      createContainer();
      viewModel = container.read(favoritesViewModelProvider.notifier);
      viewModel.state = FavoriteState(
        status: FavoriteStatus.loaded,
        favorites: tFavorites,
      );

      final result = viewModel.isFavorite('999');

      expect(result, false);
    });
  });
}
