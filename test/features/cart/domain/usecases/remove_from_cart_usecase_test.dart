
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/usecases/remove_from_cart_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late RemoveFromCartUsecase usecase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = RemoveFromCartUsecase(mockRepository);
  });

  const tParams = RemoveFromCartUsecaseParams(plantId: 'plant1');

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  group('RemoveFromCartUsecase', () {
    test('should return Right(null) when removal is successful', () async {
      when(() => mockRepository.removeFromCart(any()))
          .thenAnswer((_) async {});

      final result = await usecase(tParams);

      expect(result.isRight(), true);
      verify(() => mockRepository.removeFromCart('plant1')).called(1);
    });

    test('should return failure when removal fails', () async {
      when(() => mockRepository.removeFromCart(any()))
          .thenThrow(Exception('Failed to remove'));

      final result = await usecase(tParams);

      expect(result.isLeft(), true);
    });
  });

  group('RemoveFromCartUsecaseParams', () {
    test('should support value equality via Equatable', () {
      const params1 = RemoveFromCartUsecaseParams(plantId: 'plant1');
      const params2 = RemoveFromCartUsecaseParams(plantId: 'plant1');
      const params3 = RemoveFromCartUsecaseParams(plantId: 'plant2');

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
