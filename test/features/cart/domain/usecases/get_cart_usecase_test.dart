
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/usecases/get_cart_usecase.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late GetCartUsecase usecase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    usecase = GetCartUsecase(mockRepository);
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
    CartItemEntity(
      id: '2',
      plantId: 'plant2',
      plantName: 'Tulip Plant',
      plantImage: 'tulip.jpg',
      price: 15.99,
      quantity: 1,
    ),
  ];

  group('GetCartUsecase', () {
    test('should return list of cart items when successful', () async {
      when(() => mockRepository.getCart())
          .thenAnswer((_) async => tCartItems);

      final result = await usecase();

      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (items) => expect(items.length, 2),
      );
      verify(() => mockRepository.getCart()).called(1);
    });

    test('should return failure when getCart fails', () async {
      when(() => mockRepository.getCart())
          .thenThrow(Exception('Failed to get cart'));

      final result = await usecase();

      expect(result.isLeft(), true);
    });
  });

  group('GetCartUsecaseParams', () {
    test('should support value equality via Equatable', () {
      const params1 = GetCartUsecaseParams();
      const params2 = GetCartUsecaseParams();

      expect(params1, equals(params2));
    });
  });
}
