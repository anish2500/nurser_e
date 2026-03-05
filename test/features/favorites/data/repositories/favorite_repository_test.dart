import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/favorites/data/datasources/favorite_datasource.dart';
import 'package:nurser_e/features/favorites/data/models/favorite_api_model.dart';
import 'package:nurser_e/features/favorites/data/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/plants/data/models/plant_api_model.dart';

class MockFavoriteRemoteDatasource extends Mock
    implements IFavoritesRemoteDatasource {}

void main() {
  late FavoriteRepositoryImpl repository;
  late MockFavoriteRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockRemoteDatasource = MockFavoriteRemoteDatasource();
    repository = FavoriteRepositoryImpl(remoteDatasource: mockRemoteDatasource);
  });

  final tPlantApiModel = PlantApiModel(
    id: '1',
    name: 'Rose Plant',
    description: 'A beautiful rose',
    category: 'Flowers',
    price: 25.99,
    plantImages: ['rose.jpg'],
    stock: 10,
  );

  final tFavoriteApiModel = FavoriteApiModel(
    id: 'fav1',
    userId: 'user1',
    plants: [tPlantApiModel],
  );


  group('getFavorites', () {
    test('should return list of favorites from remote datasource', () async {
      when(() => mockRemoteDatasource.getFavorites())
          .thenAnswer((_) async => tFavoriteApiModel);

      final result = await repository.getFavorites();

      expect(result.isNotEmpty, true);
      expect(result.first.name, 'Rose Plant');
      verify(() => mockRemoteDatasource.getFavorites()).called(1);
    });

    test('should return empty list when no favorites exist', () async {
      when(() => mockRemoteDatasource.getFavorites())
          .thenAnswer((_) async => FavoriteApiModel(plants: []));

      final result = await repository.getFavorites();

      expect(result.isEmpty, true);
    });

    test('should throw exception when remote fails', () async {
      when(() => mockRemoteDatasource.getFavorites())
          .thenThrow(Exception('Network error'));

      expect(() => repository.getFavorites(), throwsException);
    });
  });

  group('addToFavorites', () {
    test('should add plant to favorites and return updated list', () async {
      when(() => mockRemoteDatasource.addToFavorites(any()))
          .thenAnswer((_) async => tFavoriteApiModel);

      final result = await repository.addToFavorites('1');

      expect(result.isNotEmpty, true);
      expect(result.first.name, 'Rose Plant');
      verify(() => mockRemoteDatasource.addToFavorites('1')).called(1);
    });

    test('should throw exception when add fails', () async {
      when(() => mockRemoteDatasource.addToFavorites(any()))
          .thenThrow(Exception('Failed to add'));

      expect(() => repository.addToFavorites('1'), throwsException);
    });
  });

  group('removeFromFavorites', () {
    test('should remove plant from favorites and return updated list',
        () async {
      when(() => mockRemoteDatasource.removeFromFavorites(any()))
          .thenAnswer((_) async => FavoriteApiModel(plants: []));

      final result = await repository.removeFromFavorites('1');

      expect(result, isA<List<FavoriteEntity>>());
      verify(() => mockRemoteDatasource.removeFromFavorites('1')).called(1);
    });

    test('should throw exception when remove fails', () async {
      when(() => mockRemoteDatasource.removeFromFavorites(any()))
          .thenThrow(Exception('Failed to remove'));

      expect(() => repository.removeFromFavorites('1'), throwsException);
    });
  });

  group('checkIsFavorite', () {
    test('should return true when plant is favorite', () async {
      when(() => mockRemoteDatasource.checkIsFavorite(any()))
          .thenAnswer((_) async => true);

      final result = await repository.checkIsFavorite('1');

      expect(result, true);
      verify(() => mockRemoteDatasource.checkIsFavorite('1')).called(1);
    });

    test('should return false when plant is not favorite', () async {
      when(() => mockRemoteDatasource.checkIsFavorite(any()))
          .thenAnswer((_) async => false);

      final result = await repository.checkIsFavorite('1');

      expect(result, false);
    });

    test('should return false when check fails', () async {
      when(() => mockRemoteDatasource.checkIsFavorite(any()))
          .thenThrow(Exception('Failed to check'));

      expect(() => repository.checkIsFavorite('1'), throwsException);
    });
  });
}
