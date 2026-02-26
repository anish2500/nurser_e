import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/services/hive/hive_service.dart';
import 'package:nurser_e/features/cart/data/datasources/remote/cart_remote_datasource.dart';
import 'package:nurser_e/features/cart/data/models/cart_api_model.dart';
import 'package:nurser_e/features/cart/data/models/cart_hive_model.dart';
import 'package:nurser_e/features/cart/data/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';

class MockCartRemoteDatasource extends Mock implements CartRemoteDatasource {}

class MockHiveService extends Mock implements HiveService {}

void main() {
  late CartRepositoryImpl repository;
  late MockCartRemoteDatasource mockRemoteDatasource;
  late MockHiveService mockHiveService;

  setUpAll(() {
    registerFallbackValue(
      CartHiveModel(
        id: '1',
        plantId: 'plant1',
        plantName: 'Test Plant',
        plantImage: 'image.jpg',
        price: 10.0,
        quantity: 1,
      ),
    );
  });

  setUp(() {
    mockRemoteDatasource = MockCartRemoteDatasource();
    mockHiveService = MockHiveService();
    repository = CartRepositoryImpl(
      remoteDatasource: mockRemoteDatasource,
      hiveService: mockHiveService,
    );
  });

  final tCartItemEntity = CartItemEntity(
    id: '1',
    plantId: 'plant1',
    plantName: 'Rose Plant',
    plantImage: 'rose.jpg',
    price: 25.99,
    quantity: 2,
  );

  final tCartHiveModel = CartHiveModel(
    id: '1',
    plantId: 'plant1',
    plantName: 'Rose Plant',
    plantImage: 'rose.jpg',
    price: 25.99,
    quantity: 2,
  );

  final tCartApiModel = CartApiModel(
    plantId: PlantIdData(
      sId: 'plant1',
      name: 'Rose Plant',
      plantImage: ['rose.jpg'],
    ),
    quantity: 2,
    price: 25.99,
  );

  group('addToCart', () {
    test('should add item to local storage and return entity', () async {
      when(() => mockHiveService.addToCart(any())).thenAnswer((_) async {});
      when(() => mockRemoteDatasource.addToCart(
            plantId: any(named: 'plantId'),
            plantName: any(named: 'plantName'),
            plantImage: any(named: 'plantImage'),
            price: any(named: 'price'),
            quantity: any(named: 'quantity'),
          )).thenAnswer((_) async => tCartApiModel);

      final result = await repository.addToCart(tCartItemEntity);

      expect(result.plantId, tCartItemEntity.plantId);
      verify(() => mockHiveService.addToCart(any())).called(1);
    });

    test('should return local item when remote fails', () async {
      when(() => mockHiveService.addToCart(any())).thenAnswer((_) async {});
      when(() => mockRemoteDatasource.addToCart(
            plantId: any(named: 'plantId'),
            plantName: any(named: 'plantName'),
            plantImage: any(named: 'plantImage'),
            price: any(named: 'price'),
            quantity: any(named: 'quantity'),
          )).thenThrow(Exception('Network error'));

      final result = await repository.addToCart(tCartItemEntity);

      expect(result.plantId, tCartItemEntity.plantId);
    });
  });

  group('getCart', () {
    test('should return cart items from remote and cache locally', () async {
      when(() => mockRemoteDatasource.getCart())
          .thenAnswer((_) async => [tCartApiModel]);
      when(() => mockHiveService.clearCart()).thenAnswer((_) async {});
      when(() => mockHiveService.addToCart(any())).thenAnswer((_) async {});

      final result = await repository.getCart();

      expect(result.isNotEmpty, true);
      verify(() => mockRemoteDatasource.getCart()).called(1);
      verify(() => mockHiveService.clearCart()).called(1);
    });

    test('should return cached items when remote fails', () async {
      when(() => mockRemoteDatasource.getCart())
          .thenThrow(Exception('Network error'));
      when(() => mockHiveService.getCartItems())
          .thenReturn([tCartHiveModel]);

      final result = await repository.getCart();

      expect(result.isNotEmpty, true);
      verify(() => mockHiveService.getCartItems()).called(1);
    });
  });

  group('removeFromCart', () {
    test('should remove item from local and remote', () async {
      when(() => mockHiveService.getCartItems())
          .thenReturn([tCartHiveModel]);
      when(() => mockHiveService.removeFromCart(any()))
          .thenAnswer((_) async {});
      when(() => mockRemoteDatasource.removeFromCart(any()))
          .thenAnswer((_) async {});

      await repository.removeFromCart('plant1');

      verify(() => mockHiveService.removeFromCart(any())).called(1);
      verify(() => mockRemoteDatasource.removeFromCart(any())).called(1);
    });
  });

  group('updateQuantity', () {
    test('should update quantity in local and remote', () async {
      final tCartApiModelUpdated = CartApiModel(
        plantId: PlantIdData(
          sId: 'plant1',
          name: 'Rose Plant',
          plantImage: ['rose.jpg'],
        ),
        quantity: 5,
        price: 25.99,
      );
      
      when(() => mockHiveService.getCartItems())
          .thenReturn([tCartHiveModel]);
      when(() => mockHiveService.updateCartItem(any()))
          .thenAnswer((_) async {});
      when(() => mockRemoteDatasource.updateCartItem(any(), any()))
          .thenAnswer((_) async => tCartApiModelUpdated);

      final result = await repository.updateQuantity('plant1', 5);

      expect(result.quantity, 5);
      verify(() => mockHiveService.updateCartItem(any())).called(1);
    });

    test('should return local item when remote fails', () async {
      when(() => mockHiveService.getCartItems())
          .thenReturn([tCartHiveModel]);
      when(() => mockHiveService.updateCartItem(any()))
          .thenAnswer((_) async {});
      when(() => mockRemoteDatasource.updateCartItem(any(), any()))
          .thenThrow(Exception('Network error'));

      final result = await repository.updateQuantity('plant1', 3);

      expect(result.quantity, 3);
    });
  });

  group('clearCart', () {
    test('should clear cart from local and remote', () async {
      when(() => mockHiveService.clearCart()).thenAnswer((_) async {});
      when(() => mockRemoteDatasource.clearCart()).thenAnswer((_) async {});

      await repository.clearCart();

      verify(() => mockHiveService.clearCart()).called(1);
      verify(() => mockRemoteDatasource.clearCart()).called(1);
    });

    test('should clear cart locally even if remote fails', () async {
      when(() => mockHiveService.clearCart()).thenAnswer((_) async {});
      when(() => mockRemoteDatasource.clearCart())
          .thenThrow(Exception('Network error'));

      await repository.clearCart();

      verify(() => mockHiveService.clearCart()).called(1);
    });
  });

  group('checkout', () {
    test('should return response from remote checkout', () async {
      const tResponse = {'success': true, 'orderId': 'order123'};
      when(() => mockRemoteDatasource.checkout(
            items: any(named: 'items'),
            totalAmount: any(named: 'totalAmount'),
          )).thenAnswer((_) async => tResponse);

      final result = await repository.checkout(
        items: [tCartItemEntity],
        totalAmount: 51.98,
      );

      expect(result['success'], true);
      expect(result['orderId'], 'order123');
    });
  });
}
