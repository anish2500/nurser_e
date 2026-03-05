import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/orders/data/repositories/order_repository.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';
import 'package:nurser_e/features/orders/presentation/state/order_state.dart';
import 'package:nurser_e/features/orders/presentation/view_model/order_view_model.dart';

class MockOrderRepositoryImpl extends Mock implements OrderRepositoryImpl {}

void main() {
  late OrderViewModel viewModel;
  late MockOrderRepositoryImpl mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockOrderRepositoryImpl();
  });

  tearDown(() {
    container.dispose();
  });

  ProviderContainer createContainer() {
    container = ProviderContainer(
      overrides: [
        orderRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    return container;
  }

  final tOrders = [
    OrderEntity(
      id: 'order1',
      userId: 'user1',
      items: [],
      totalAmount: 100.0,
      paymentMethod: 'cash_on_delivery',
      orderStatus: 'pending',
      paymentStatus: 'pending',
      createdAt: DateTime.now(),
    ),
  ];

  group('loadOrders', () {
    test('should update state to loaded with orders', () async {
      when(() => mockRepository.getOrders()).thenAnswer((_) async => tOrders);

      createContainer();
      viewModel = container.read(orderViewModelProvider.notifier);

      await viewModel.loadOrders();

      expect(viewModel.state.status, OrderStatus.loaded);
      expect(viewModel.state.orders.length, 1);
    });

    test('should update state to loading initially', () async {
      when(() => mockRepository.getOrders()).thenAnswer((_) async => tOrders);

      createContainer();
      viewModel = container.read(orderViewModelProvider.notifier);

      final future = viewModel.loadOrders();
      await Future.delayed(const Duration(milliseconds: 10));
      await future;

      expect(viewModel.state.status, OrderStatus.loaded);
    });

    test('should update state to error when exception occurs', () async {
      when(() => mockRepository.getOrders()).thenThrow(Exception('Failed to load'));

      createContainer();
      viewModel = container.read(orderViewModelProvider.notifier);

      await viewModel.loadOrders();

      expect(viewModel.state.status, OrderStatus.error);
    });
  });

  group('refreshOrders', () {
    test('should refresh orders successfully', () async {
      when(() => mockRepository.getOrders()).thenAnswer((_) async => tOrders);

      createContainer();
      viewModel = container.read(orderViewModelProvider.notifier);

      await viewModel.refreshOrders();

      expect(viewModel.state.status, OrderStatus.loaded);
      expect(viewModel.state.orders.length, 1);
    });

    test('should set error state when refresh fails', () async {
      when(() => mockRepository.getOrders()).thenThrow(Exception('Failed'));

      createContainer();
      viewModel = container.read(orderViewModelProvider.notifier);

      await viewModel.refreshOrders();

      expect(viewModel.state.status, OrderStatus.error);
    });
  });

  group('cancelOrder', () {
    test('should cancel order and return true', () async {
      when(() => mockRepository.cancelOrder(any())).thenAnswer((_) async => tOrders.first);

      createContainer();
      viewModel = container.read(orderViewModelProvider.notifier);
      viewModel.state = OrderState(
        status: OrderStatus.loaded,
        orders: tOrders,
      );

      final result = await viewModel.cancelOrder('order1');

      expect(result, true);
    });

    test('should return false when cancel fails', () async {
      when(() => mockRepository.cancelOrder(any())).thenThrow(Exception('Failed'));

      createContainer();
      viewModel = container.read(orderViewModelProvider.notifier);
      viewModel.state = OrderState(
        status: OrderStatus.loaded,
        orders: tOrders,
      );

      final result = await viewModel.cancelOrder('order1');

      expect(result, false);
    });
  });
}
