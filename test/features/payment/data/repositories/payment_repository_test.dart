
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/payment/data/datasources/remote/payment_remote_datasource.dart';
import 'package:nurser_e/features/payment/data/models/payment_api_model.dart';
import 'package:nurser_e/features/payment/data/repositories/payment_repository.dart';
import 'package:nurser_e/features/payment/domain/entities/payment_entity.dart';

class MockPaymentRemoteDatasource extends Mock implements PaymentRemoteDatasource {}

void main() {
  late PaymentRepositoryImpl repository;
  late MockPaymentRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockRemoteDatasource = MockPaymentRemoteDatasource();
    repository = PaymentRepositoryImpl(remoteDatasource: mockRemoteDatasource);
  });

  final tPaymentApiModel = PaymentApiModel(
    orderId: 'order123',
    totalAmount: 100.0,
    paymentMethod: 'cash_on_delivery',
    paymentStatus: 'paid',
    transactionId: 'txn123',
    paidAt: DateTime.now(),
    createdAt: DateTime.now(),
  );

  final tPaymentEntity = PaymentEntity(
    orderId: 'order123',
    amount: 100.0,
    paymentMethod: 'cash_on_delivery',
    paymentStatus: 'paid',
    transactionId: 'txn123',
    paidAt: DateTime.now(),
    createdAt: DateTime.now(),
  );

  final tItems = [
    {'plantId': '1', 'name': 'Rose Plant', 'price': 50.0, 'quantity': 2},
  ];

  group('createPayment', () {
    test('should return payment entity when remote call succeeds', () async {
      when(() => mockRemoteDatasource.createPayment(
        items: any(named: 'items'),
        totalAmount: any(named: 'totalAmount'),
        paymentMethod: any(named: 'paymentMethod'),
        transactionId: any(named: 'transactionId'),
      )).thenAnswer((_) async => tPaymentApiModel);

      final result = await repository.createPayment(
        items: tItems,
        totalAmount: 100.0,
        paymentMethod: 'cash_on_delivery',
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return payment'),
        (payment) => expect(payment.orderId, 'order123'),
      );
      verify(() => mockRemoteDatasource.createPayment(
        items: tItems,
        totalAmount: 100.0,
        paymentMethod: 'cash_on_delivery',
        transactionId: null,
      )).called(1);
    });

    test('should return ApiFailure when DioException occurs', () async {
      when(() => mockRemoteDatasource.createPayment(
        items: any(named: 'items'),
        totalAmount: any(named: 'totalAmount'),
        paymentMethod: any(named: 'paymentMethod'),
        transactionId: any(named: 'transactionId'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/orders'),
        response: Response(
          data: {'message': 'Payment failed'},
          requestOptions: RequestOptions(path: '/orders'),
        ),
      ));

      final result = await repository.createPayment(
        items: tItems,
        totalAmount: 100.0,
        paymentMethod: 'cash_on_delivery',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });

    test('should return ApiFailure when general exception occurs', () async {
      when(() => mockRemoteDatasource.createPayment(
        items: any(named: 'items'),
        totalAmount: any(named: 'totalAmount'),
        paymentMethod: any(named: 'paymentMethod'),
        transactionId: any(named: 'transactionId'),
      )).thenThrow(Exception('Unknown error'));

      final result = await repository.createPayment(
        items: tItems,
        totalAmount: 100.0,
        paymentMethod: 'cash_on_delivery',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getPaymentStatus', () {
    test('should return payment entity when remote call succeeds', () async {
      when(() => mockRemoteDatasource.getPaymentStatus(any()))
          .thenAnswer((_) async => tPaymentApiModel);

      final result = await repository.getPaymentStatus('order123');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return payment'),
        (payment) => expect(payment.orderId, 'order123'),
      );
      verify(() => mockRemoteDatasource.getPaymentStatus('order123')).called(1);
    });

    test('should return ApiFailure when DioException occurs', () async {
      when(() => mockRemoteDatasource.getPaymentStatus(any()))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: '/orders/order123'),
      ));

      final result = await repository.getPaymentStatus('order123');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('updatePaymentStatus', () {
    test('should return payment entity when remote call succeeds', () async {
      when(() => mockRemoteDatasource.updatePaymentStatus(
        orderId: any(named: 'orderId'),
        status: any(named: 'status'),
        transactionId: any(named: 'transactionId'),
      )).thenAnswer((_) async => tPaymentApiModel);

      final result = await repository.updatePaymentStatus(
        orderId: 'order123',
        status: 'paid',
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return payment'),
        (payment) => expect(payment.orderId, 'order123'),
      );
      verify(() => mockRemoteDatasource.updatePaymentStatus(
        orderId: 'order123',
        status: 'paid',
        transactionId: null,
      )).called(1);
    });

    test('should return ApiFailure when DioException occurs', () async {
      when(() => mockRemoteDatasource.updatePaymentStatus(
        orderId: any(named: 'orderId'),
        status: any(named: 'status'),
        transactionId: any(named: 'transactionId'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/orders/order123/payment'),
      ));

      final result = await repository.updatePaymentStatus(
        orderId: 'order123',
        status: 'paid',
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });
}
