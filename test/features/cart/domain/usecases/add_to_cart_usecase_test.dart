import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/usecases/add_to_cart_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

class FakeCartItemEntity extends Fake implements CartItemEntity {}

void main() {
  late AddToCartUsecase usecase;
  late MockCartRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeCartItemEntity());
  });

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = AddToCartUsecase(mockRepository);
  });

  const tParams = AddToCartUsecaseParams(
    plantId: 'plant1',
    plantName: 'Rose Plant',
    plantImage: 'rose.jpg',
    price: 25.99,
    quantity: 2,
  );

  final tCartItemEntity = CartItemEntity(
    id: '1',
    plantId: 'plant1',
    plantName: 'Rose Plant',
    plantImage: 'rose.jpg',
    price: 25.99,
    quantity: 2,
  );

  group('AddToCartUsecase', () {
    test('should return CartItemEntity when addition is successful', () async {
      when(() => mockRepository.addToCart(any()))
          .thenAnswer((_) async => tCartItemEntity);

      final result = await usecase(tParams);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (entity) => expect(entity.plantId, tParams.plantId),
      );
      verify(() => mockRepository.addToCart(any())).called(1);
    });

    test('should return failure when addition fails', () async {
      when(() => mockRepository.addToCart(any()))
          .thenThrow(Exception('Failed to add'));

      final result = await usecase(tParams);

      expect(result.isLeft(), true);
    });
  });

  group('AddToCartUsecaseParams', () {
    test('should support value equality via Equatable', () {
      const params1 = AddToCartUsecaseParams(
        plantId: 'plant1',
        plantName: 'Rose Plant',
        plantImage: 'rose.jpg',
        price: 25.99,
        quantity: 2,
      );

      const params2 = AddToCartUsecaseParams(
        plantId: 'plant1',
        plantName: 'Rose Plant',
        plantImage: 'rose.jpg',
        price: 25.99,
        quantity: 2,
      );

      expect(params1, equals(params2));
    });
  });
}
