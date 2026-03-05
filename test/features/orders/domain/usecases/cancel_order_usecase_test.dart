
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';
import 'package:nurser_e/features/orders/domain/repositories/order_repository.dart';
import 'package:nurser_e/features/orders/domain/usecases/cancel_order_usecase.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late CancelOrderUsecase usecase;
  late MockOrderRepository mockRepository;

  setUp(() {
    mockRepository = MockOrderRepository();
    usecase = CancelOrderUsecase(mockRepository);
  });

  final tCancelledOrder = OrderEntity(
    id: 'order1',
    userId: 'user1',
    items: [
      OrderItemEntity(
        id: 'item1',
        plantId: 'plant1',
        plantName: 'Rose Plant',
        plantImage: 'rose.jpg',
        price: 25.99,
        quantity: 2,
      ),
    ],
    totalAmount: 51.98,
    paymentMethod: 'cash_on_delivery',
    orderStatus: 'cancelled',
    paymentStatus: 'refunded',
    createdAt: DateTime.now(),
  );

  group('CancelOrderUsecase', () {
    test('should return cancelled order when repository call is successful', () async {
      when(() => mockRepository.cancelOrder(any())).thenAnswer((_) async => tCancelledOrder);

      final result = await usecase(const CancelOrderUsecaseParams(orderId: 'order1'));

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return order'),
        (order) => expect(order.orderStatus, 'cancelled'),
      );
      verify(() => mockRepository.cancelOrder('order1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
