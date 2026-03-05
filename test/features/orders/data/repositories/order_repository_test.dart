import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/orders/data/datasources/remote/order_remote_datasource.dart';
import 'package:nurser_e/features/orders/data/models/order_api_model.dart';
import 'package:nurser_e/features/orders/data/repositories/order_repository.dart';


class MockOrderRemoteDatasource extends Mock implements OrderRemoteDatasource {}

void main() {
  late OrderRepositoryImpl repository;
  late MockOrderRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockRemoteDatasource = MockOrderRemoteDatasource();
    repository = OrderRepositoryImpl(remoteDatasource: mockRemoteDatasource);
  });

  final tOrderApiModel = OrderApiModel(
    id: 'order1',
    userId: 'user1',
    items: [
      OrderItem(
        id: 'item1',
        plantId: PlantData(sId: 'plant1', name: 'Rose Plant', price: 25.99, plantImage: ['rose.jpg']),
        quantity: 2,
        price: 25.99,
      ),
    ],
    totalAmount: 51.98,
    paymentMethod: 'cash_on_delivery',
    orderStatus: 'pending',
    paymentStatus: 'pending',
    createdAt: DateTime.now(),
  );


  group('getOrders', () {
    test('should return list of orders when remote call succeeds', () async {
      when(() => mockRemoteDatasource.getOrders())
          .thenAnswer((_) async => [tOrderApiModel]);

      final result = await repository.getOrders();

      expect(result.isNotEmpty, true);
      expect(result.first.id, 'order1');
      verify(() => mockRemoteDatasource.getOrders()).called(1);
    });
  });

  group('getOrderById', () {
    test('should return order when remote call succeeds', () async {
      when(() => mockRemoteDatasource.getOrderById(any()))
          .thenAnswer((_) async => tOrderApiModel);

      final result = await repository.getOrderById('order1');

      expect(result.id, 'order1');
      verify(() => mockRemoteDatasource.getOrderById('order1')).called(1);
    });
  });

  group('cancelOrder', () {
    test('should return cancelled order when remote call succeeds', () async {
      final cancelledOrder = OrderApiModel(
        id: 'order1',
        userId: 'user1',
        items: tOrderApiModel.items,
        totalAmount: 51.98,
        paymentMethod: 'cash_on_delivery',
        orderStatus: 'cancelled',
        paymentStatus: 'refunded',
        createdAt: DateTime.now(),
      );

      when(() => mockRemoteDatasource.cancelOrder(any()))
          .thenAnswer((_) async => cancelledOrder);

      final result = await repository.cancelOrder('order1');

      expect(result.orderStatus, 'cancelled');
      verify(() => mockRemoteDatasource.cancelOrder('order1')).called(1);
    });
  });
}
