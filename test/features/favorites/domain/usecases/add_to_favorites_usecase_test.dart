import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/usecases/add_to_favorites_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late AddToFavoritesUsecase usecase;
  late MockFavoriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    usecase = AddToFavoritesUsecase(mockRepository);
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
  ];

  group('AddToFavoritesUsecase', () {
    test('should add plant to favorites and return updated list', () async {
      when(() => mockRepository.addToFavorites(any()))
          .thenAnswer((_) async => tFavorites);

      final result = await usecase(
        const AddToFavoritesUsecaseParams(plantId: '1'),
      );

      expect(result, Right(tFavorites));
      verify(() => mockRepository.addToFavorites('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
