import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/features/payment/domain/entities/payment_entity.dart';
import 'package:nurser_e/features/payment/domain/repositories/payment_repository.dart';
import 'package:nurser_e/features/payment/domain/usecases/get_payment_status_usecase.dart';

class MockPaymentRepository extends Mock implements IPaymentRepository {}

void main() {
  late GetPaymentStatusUsecase usecase;
  late MockPaymentRepository mockRepository;

  setUp(() {
    mockRepository = MockPaymentRepository();
    usecase = GetPaymentStatusUsecase(mockRepository);
  });

  final tPaymentEntity = PaymentEntity(
    orderId: 'order123',
    amount: 100.0,
    paymentMethod: 'cash_on_delivery',
    paymentStatus: 'paid',
    transactionId: 'txn123',
    createdAt: DateTime.now(),
  );

  group('GetPaymentStatusUsecase', () {
    test('should return payment entity when repository call is successful', () async {
      when(() => mockRepository.getPaymentStatus(any()))
          .thenAnswer((_) async => Right(tPaymentEntity));

      final result = await usecase(
        const GetPaymentStatusUsecaseParams(orderId: 'order123'),
      );

      expect(result, Right(tPaymentEntity));
      verify(() => mockRepository.getPaymentStatus('order123')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
