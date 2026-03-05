import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/payment/domain/entities/payment_entity.dart';
import 'package:nurser_e/features/payment/domain/repositories/payment_repository.dart';
import 'package:nurser_e/features/payment/domain/usecases/update_payment_status_usecase.dart';

class MockPaymentRepository extends Mock implements IPaymentRepository {}

void main() {
  late UpdatePaymentStatusUsecase usecase;
  late MockPaymentRepository mockRepository;

  setUp(() {
    mockRepository = MockPaymentRepository();
    usecase = UpdatePaymentStatusUsecase(mockRepository);
  });

  final tPaymentEntity = PaymentEntity(
    orderId: 'order123',
    amount: 100.0,
    paymentMethod: 'cash_on_delivery',
    paymentStatus: 'paid',
    transactionId: 'txn123',
    createdAt: DateTime.now(),
  );

  group('UpdatePaymentStatusUsecase', () {
    test('should return payment entity when repository call is successful', () async {
      when(() => mockRepository.updatePaymentStatus(
        orderId: any(named: 'orderId'),
        status: any(named: 'status'),
        transactionId: any(named: 'transactionId'),
      )).thenAnswer((_) async => Right(tPaymentEntity));

      final result = await usecase(
        const UpdatePaymentStatusUsecaseParams(
          orderId: 'order123',
          status: 'paid',
        ),
      );

      expect(result, Right(tPaymentEntity));
      verify(() => mockRepository.updatePaymentStatus(
        orderId: 'order123',
        status: 'paid',
        transactionId: null,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
