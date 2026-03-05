import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/usecases/get_favorites_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late GetFavoritesUsecase usecase;
  late MockFavoriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    usecase = GetFavoritesUsecase(mockRepository);
  });

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
    FavoriteEntity(
      id: '2',
      plantId: '2',
      name: 'Tulip Plant',
      category: 'Flowers',
      description: 'A colorful tulip',
      price: 15.99,
      plantImages: ['tulip.jpg'],
      stock: 20,
    ),
  ];

  group('GetFavoritesUsecase', () {
    test('should return list of favorites when repository call is successful',
        () async {
      when(() => mockRepository.getFavorites())
          .thenAnswer((_) async => tFavorites);

      final result = await usecase();

      expect(result, Right(tFavorites));
      verify(() => mockRepository.getFavorites()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
