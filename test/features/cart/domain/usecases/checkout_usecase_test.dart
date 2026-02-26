import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/usecases/checkout_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late CheckoutUsecase usecase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = CheckoutUsecase(mockRepository);
  });

  final tCartItems = [
    CartItemEntity(
      id: '1',
      plantId: 'plant1',
      plantName: 'Rose Plant',
      plantImage: 'rose.jpg',
      price: 25.99,
      quantity: 2,
    ),
  ];

  const tParams = CheckoutUsecaseParams(
    items: [],
    totalAmount: 51.98,
  );

  const tResponse = {
    'success': true,
    'orderId': 'order123',
  };

  setUpAll(() {
    registerFallbackValue(tParams);
  });

  group('CheckoutUsecase', () {
    test('should return response when checkout is successful', () async {
      when(() => mockRepository.checkout(
            items: any(named: 'items'),
            totalAmount: any(named: 'totalAmount'),
          )).thenAnswer((_) async => tResponse);

      final result = await usecase(tParams);

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (response) => expect(response['success'], true),
      );
    });

    test('should return failure when checkout fails', () async {
      when(() => mockRepository.checkout(
            items: any(named: 'items'),
            totalAmount: any(named: 'totalAmount'),
          )).thenThrow(Exception('Checkout failed'));

      final result = await usecase(tParams);

      expect(result.isLeft(), true);
    });
  });

  group('CheckoutUsecaseParams', () {
    test('should support value equality via Equatable', () {
      const params1 = CheckoutUsecaseParams(
        items: [],
        totalAmount: 51.98,
      );
      const params2 = CheckoutUsecaseParams(
        items: [],
        totalAmount: 51.98,
      );
      const params3 = CheckoutUsecaseParams(
        items: [],
        totalAmount: 100.00,
      );

      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });
  });
}
