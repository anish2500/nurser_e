
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/cart/data/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/domain/repositories/cart_repository.dart';
import 'package:nurser_e/features/cart/presentation/state/cart_state.dart';
import 'package:nurser_e/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';

class MockCartRepository extends Mock implements CartRepository {}

class FakeCartItemEntity extends Fake implements CartItemEntity {}

void main() {
  late MockCartRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(FakeCartItemEntity());
  });

  setUp(() {
    mockRepository = MockCartRepository();
    container = ProviderContainer(
      overrides: [
        cartRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
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

  final tPlant = PlantEntity(
    id: 'plant1',
    name: 'Rose Plant',
    description: 'Beautiful rose',
    category: 'Flowers',
    price: 25.99,
    plantImages: ['rose.jpg'],
    stock: 10,
  );

  group('CartViewModel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        final state = container.read(cartViewModelProvider);

        expect(state.status, CartStatus.initial);
        expect(state.items, isEmpty);
        expect(state.errorMessage, isNull);
      });
    });

    group('loadCart', () {
      test('should emit loaded state with items when successful', () async {
        when(() => mockRepository.getCart())
            .thenAnswer((_) async => tCartItems);

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.loadCart();

        final state = container.read(cartViewModelProvider);
        expect(state.status, CartStatus.loaded);
        expect(state.items.length, 2);
        verify(() => mockRepository.getCart()).called(1);
      });

      test('should emit error state when failed', () async {
        when(() => mockRepository.getCart())
            .thenThrow(Exception('Failed to load cart'));

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.loadCart();

        final state = container.read(cartViewModelProvider);
        expect(state.status, CartStatus.error);
        expect(state.errorMessage, contains('Failed to load cart'));
      });
    });

    group('addToCart', () {
      test('should add plant to cart and reload', () async {
        when(() => mockRepository.addToCart(any()))
            .thenAnswer((_) async => tCartItems.first);
        when(() => mockRepository.getCart())
            .thenAnswer((_) async => tCartItems);

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.addToCart(tPlant);

        verify(() => mockRepository.addToCart(any())).called(1);
        verify(() => mockRepository.getCart()).called(1);
      });

      test('should emit error when addToCart fails', () async {
        when(() => mockRepository.addToCart(any()))
            .thenThrow(Exception('Failed to add'));

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.addToCart(tPlant);

        final state = container.read(cartViewModelProvider);
        expect(state.status, CartStatus.error);
      });
    });

    group('updateQuantity', () {
      test('should update quantity and reload cart', () async {
        when(() => mockRepository.updateQuantity(any(), any()))
            .thenAnswer((_) async => tCartItems.first);
        when(() => mockRepository.getCart())
            .thenAnswer((_) async => tCartItems);

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.updateQuantity('plant1', 5);

        verify(() => mockRepository.updateQuantity('plant1', 5)).called(1);
        verify(() => mockRepository.getCart()).called(1);
      });

      test('should not update when quantity is less than 1', () async {
        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.updateQuantity('plant1', 0);

        verifyNever(() => mockRepository.updateQuantity(any(), any()));
      });

      test('should emit error when update fails', () async {
        when(() => mockRepository.updateQuantity(any(), any()))
            .thenThrow(Exception('Failed to update'));

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.updateQuantity('plant1', 5);

        final state = container.read(cartViewModelProvider);
        expect(state.status, CartStatus.error);
      });
    });

    group('removeFromCart', () {
      test('should remove item and reload cart', () async {
        when(() => mockRepository.removeFromCart(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.getCart())
            .thenAnswer((_) async => [tCartItems.last]);

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.removeFromCart('plant1');

        verify(() => mockRepository.removeFromCart('plant1')).called(1);
        verify(() => mockRepository.getCart()).called(1);
      });

      test('should emit error when removal fails', () async {
        when(() => mockRepository.removeFromCart(any()))
            .thenThrow(Exception('Failed to remove'));

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.removeFromCart('plant1');

        final state = container.read(cartViewModelProvider);
        expect(state.status, CartStatus.error);
      });
    });

    group('clearCart', () {
      test('should clear cart and reset to initial state', () async {
        when(() => mockRepository.clearCart()).thenAnswer((_) async {});

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.clearCart();

        final state = container.read(cartViewModelProvider);
        expect(state.status, CartStatus.initial);
        expect(state.items, isEmpty);
        verify(() => mockRepository.clearCart()).called(1);
      });

      test('should emit error when clear fails', () async {
        when(() => mockRepository.clearCart())
            .thenThrow(Exception('Failed to clear'));

        final viewModel = container.read(cartViewModelProvider.notifier);

        await viewModel.clearCart();

        final state = container.read(cartViewModelProvider);
        expect(state.status, CartStatus.error);
      });
    });

    group('checkout', () {
      test('should checkout and return response', () async {
        const tResponse = {'success': true, 'orderId': 'order123'};
        
        container.read(cartViewModelProvider.notifier).state = 
            container.read(cartViewModelProvider).copyWith(items: tCartItems);
        
        when(() => mockRepository.checkout(
          items: any(named: 'items'),
          totalAmount: any(named: 'totalAmount'),
        )).thenAnswer((_) async => tResponse);

        final viewModel = container.read(cartViewModelProvider.notifier);

        final result = await viewModel.checkout();

        expect(result['success'], true);
        verify(() => mockRepository.checkout(
          items: any(named: 'items'),
          totalAmount: any(named: 'totalAmount'),
        )).called(1);
      });

      test('should emit error when checkout fails', () async {
        container.read(cartViewModelProvider.notifier).state = 
            container.read(cartViewModelProvider).copyWith(items: tCartItems);
            
        when(() => mockRepository.checkout(
          items: any(named: 'items'),
          totalAmount: any(named: 'totalAmount'),
        )).thenThrow(Exception('Checkout failed'));

        final viewModel = container.read(cartViewModelProvider.notifier);

        try {
          await viewModel.checkout();
        } catch (_) {}

        final state = container.read(cartViewModelProvider);
        expect(state.status, CartStatus.error);
      });
    });
  });

  group('CartState', () {
    test('should have correct initial values', () {
      const state = CartState(
        status: CartStatus.initial,
        items: [],
        errorMessage: null,
      );

      expect(state.status, CartStatus.initial);
      expect(state.items, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('should calculate totalAmount correctly', () {
      final state = CartState(
        status: CartStatus.loaded,
        items: tCartItems,
      );

      expect(state.totalAmount, 67.97); // (25.99*2) + (15.99*1)
    });

    test('should calculate totalItems correctly', () {
      final state = CartState(
        status: CartStatus.loaded,
        items: tCartItems,
      );

      expect(state.totalItems, 3); // 2 + 1
    });

    test('copyWith should update specified fields', () {
      const state = CartState(
        status: CartStatus.initial,
        items: [],
      );

      final newState = state.copyWith(
        status: CartStatus.loaded,
        items: tCartItems,
      );

      expect(newState.status, CartStatus.loaded);
      expect(newState.items, tCartItems);
    });

    test('props should contain all fields', () {
      final state = CartState(
        status: CartStatus.loaded,
        items: tCartItems,
        errorMessage: 'error',
      );

      expect(state.props, [CartStatus.loaded, tCartItems, 'error']);
    });
  });
}
