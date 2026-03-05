import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/payment/domain/entities/payment_entity.dart';
import 'package:nurser_e/features/payment/domain/repositories/payment_repository.dart';
import 'package:nurser_e/features/payment/domain/usecases/create_payment_usecase.dart';

class MockPaymentRepository extends Mock implements IPaymentRepository {}

void main() {
  late CreatePaymentUsecase usecase;
  late MockPaymentRepository mockRepository;

  setUp(() {
    mockRepository = MockPaymentRepository();
    usecase = CreatePaymentUsecase(mockRepository);
  });

  final tPaymentEntity = PaymentEntity(
    orderId: 'order123',
    amount: 100.0,
    paymentMethod: 'cash_on_delivery',
    paymentStatus: 'paid',
    transactionId: 'txn123',
    createdAt: DateTime.now(),
  );

  final tParams = CreatePaymentUsecaseParams(
    items: [
      {'plantId': '1', 'name': 'Rose Plant', 'price': 50.0, 'quantity': 2},
    ],
    totalAmount: 100.0,
    paymentMethod: 'cash_on_delivery',
  );

  group('CreatePaymentUsecase', () {
    test('should return payment entity when repository call is successful', () async {
      when(() => mockRepository.createPayment(
        items: any(named: 'items'),
        totalAmount: any(named: 'totalAmount'),
        paymentMethod: any(named: 'paymentMethod'),
        transactionId: any(named: 'transactionId'),
      )).thenAnswer((_) async => Right(tPaymentEntity));

      final result = await usecase(tParams);

      expect(result, Right(tPaymentEntity));
      verify(() => mockRepository.createPayment(
        items: tParams.items,
        totalAmount: tParams.totalAmount,
        paymentMethod: tParams.paymentMethod,
        transactionId: tParams.transactionId,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
