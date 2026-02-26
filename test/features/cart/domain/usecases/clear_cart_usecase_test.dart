
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/usecases/clear_cart_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late ClearCartUsecase usecase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = ClearCartUsecase(mockRepository);
  });

  group('ClearCartUsecase', () {
    test('should return Right(null) when clear is successful', () async {
      when(() => mockRepository.clearCart()).thenAnswer((_) async {});

      final result = await usecase();

      expect(result.isRight(), true);
      verify(() => mockRepository.clearCart()).called(1);
    });

    test('should return failure when clear fails', () async {
      when(() => mockRepository.clearCart())
          .thenThrow(Exception('Failed to clear'));

      final result = await usecase();

      expect(result.isLeft(), true);
    });
  });

  group('ClearCartUsecaseParams', () {
    test('should support value equality via Equatable', () {
      const params1 = ClearCartUsecaseParams();
      const params2 = ClearCartUsecaseParams();

      expect(params1, equals(params2));
    });
  });
}
