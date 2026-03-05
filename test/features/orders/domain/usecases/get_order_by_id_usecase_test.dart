import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';
import 'package:nurser_e/features/orders/domain/repositories/order_repository.dart';
import 'package:nurser_e/features/orders/domain/usecases/get_order_by_id_usecase.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

void main() {
  late GetOrderByIdUsecase usecase;
  late MockOrderRepository mockRepository;

  setUp(() {
    mockRepository = MockOrderRepository();
    usecase = GetOrderByIdUsecase(mockRepository);
  });

  final tOrder = OrderEntity(
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
    orderStatus: 'pending',
    paymentStatus: 'pending',
    createdAt: DateTime.now(),
  );

  group('GetOrderByIdUsecase', () {
    test('should return order when repository call is successful', () async {
      when(() => mockRepository.getOrderById(any())).thenAnswer((_) async => tOrder);

      final result = await usecase(const GetOrderByIdUsecaseParams(orderId: 'order1'));

      expect(result, Right(tOrder));
      verify(() => mockRepository.getOrderById('order1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
