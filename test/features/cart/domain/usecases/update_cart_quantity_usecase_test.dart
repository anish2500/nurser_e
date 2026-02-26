
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/usecases/update_cart_quantity_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late UpdateCartQuantityUsecase usecase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = UpdateCartQuantityUsecase(mockRepository);
  });

  const tParams = UpdateCartQuantityUsecaseParams(
    plantId: 'plant1',
    quantity: 5,
  );

  final tCartItemEntity = CartItemEntity(
    id: '1',
    plantId: 'plant1',
    plantName: 'Rose Plant',
    plantImage: 'rose.jpg',
    price: 25.99,
    quantity: 5,
  );

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  group('UpdateCartQuantityUsecase', () {
    test('should return updated CartItemEntity when successful', () async {
      when(() => mockRepository.updateQuantity(any(), any()))
          .thenAnswer((_) async => tCartItemEntity);

      final result = await usecase(tParams);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (entity) => expect(entity.quantity, 5),
      );
    });

    test('should return failure when update fails', () async {
      when(() => mockRepository.updateQuantity(any(), any()))
          .thenThrow(Exception('Failed to update'));

      final result = await usecase(tParams);

      expect(result.isLeft(), true);
    });
  });

  group('UpdateCartQuantityUsecaseParams', () {
    test('should support value equality via Equatable', () {
      const params1 = UpdateCartQuantityUsecaseParams(
        plantId: 'plant1',
        quantity: 5,
      );
      const params2 = UpdateCartQuantityUsecaseParams(
        plantId: 'plant1',
        quantity: 5,
      );
      const params3 = UpdateCartQuantityUsecaseParams(
        plantId: 'plant1',
        quantity: 3,
      );

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
