
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/usecases/remove_from_favorites_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late RemoveFromFavoritesUsecase usecase;
  late MockFavoriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    usecase = RemoveFromFavoritesUsecase(mockRepository);
  });

  group('RemoveFromFavoritesUsecase', () {
    test('should remove plant from favorites and return updated list', () async {
      when(() => mockRepository.removeFromFavorites(any()))
          .thenAnswer((_) async => []);

      final result = await usecase(
        const RemoveFromFavoritesUsecaseParams(plantId: '1'),
      );

      expect(result.getOrElse(() => []), isEmpty);
      verify(() => mockRepository.removeFromFavorites('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
