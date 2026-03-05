import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:nurser_e/features/favorites/domain/usecases/check_is_favorite_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoriteRepository extends Mock implements FavoriteRepository {}

void main() {
  late CheckIsFavoriteUsecase usecase;
  late MockFavoriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    usecase = CheckIsFavoriteUsecase(mockRepository);
  });

  group('CheckIsFavoriteUsecase', () {
    test('should return true when plant is favorite', () async {
      when(() => mockRepository.checkIsFavorite(any()))
          .thenAnswer((_) async => true);

      final result = await usecase(
        const CheckIsFavoriteUsecaseParams(plantId: '1'),
      );

      expect(result, const Right(true));
      verify(() => mockRepository.checkIsFavorite('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
