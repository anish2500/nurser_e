import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nurser_e/core/error/failures.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/payment/data/repositories/payment_repository.dart';
import 'package:nurser_e/features/payment/domain/entities/payment_entity.dart';
import 'package:nurser_e/features/payment/presentation/state/payment_state.dart';
import 'package:nurser_e/features/payment/presentation/view_model/payment_view_model.dart';

class MockPaymentRepositoryImpl extends Mock implements PaymentRepositoryImpl {}

void main() {
  late PaymentViewModel viewModel;
  late MockPaymentRepositoryImpl mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockPaymentRepositoryImpl();
  });

  tearDown(() {
    container.dispose();
  });

  ProviderContainer createContainer() {
    container = ProviderContainer(
      overrides: [
        paymentRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    return container;
  }

  final tPaymentEntity = PaymentEntity(
    orderId: 'order123',
    amount: 100.0,
    paymentMethod: 'cash_on_delivery',
    paymentStatus: 'paid',
    transactionId: 'txn123',
    createdAt: DateTime.now(),
  );

  final tCartItems = [
    CartItemEntity(
      id: '1',
      plantId: 'plant1',
      plantName: 'Rose Plant',
      plantImage: 'rose.jpg',
      price: 50.0,
      quantity: 2,
    ),
  ];

  group('initPaymentData', () {
    test('should initialize payment data with cart items', () {
      createContainer();
      viewModel = container.read(paymentViewModelProvider.notifier);

      viewModel.initPaymentData(tCartItems, 100.0);

      expect(viewModel.state.cartItems.length, 1);
      expect(viewModel.state.totalAmount, 100.0);
      expect(viewModel.state.status, PaymentStatus.initial);
    });
  });

  group('processPayment', () {
    test('should return true when payment is successful', () async {
      when(() => mockRepository.createPayment(
        items: any(named: 'items'),
        totalAmount: any(named: 'totalAmount'),
        paymentMethod: any(named: 'paymentMethod'),
        transactionId: any(named: 'transactionId'),
      )).thenAnswer((_) async => Right(tPaymentEntity));

      createContainer();
      viewModel = container.read(paymentViewModelProvider.notifier);
      viewModel.initPaymentData(tCartItems, 100.0);

      final result = await viewModel.processPayment(paymentMethod: 'cash_on_delivery');

      expect(result, true);
      expect(viewModel.state.status, PaymentStatus.success);
    });

    test('should return false when payment fails', () async {
      when(() => mockRepository.createPayment(
        items: any(named: 'items'),
        totalAmount: any(named: 'totalAmount'),
        paymentMethod: any(named: 'paymentMethod'),
        transactionId: any(named: 'transactionId'),
      )).thenAnswer((_) async => const Left(ApiFailure(message: 'Payment failed')));

      createContainer();
      viewModel = container.read(paymentViewModelProvider.notifier);
      viewModel.initPaymentData(tCartItems, 100.0);

      final result = await viewModel.processPayment(paymentMethod: 'cash_on_delivery');

      expect(result, false);
      expect(viewModel.state.status, PaymentStatus.failure);
    });
  });

  group('updatePaymentStatus', () {
    test('should return true when update is successful', () async {
      when(() => mockRepository.updatePaymentStatus(
        orderId: any(named: 'orderId'),
        status: any(named: 'status'),
        transactionId: any(named: 'transactionId'),
      )).thenAnswer((_) async => Right(tPaymentEntity));

      createContainer();
      viewModel = container.read(paymentViewModelProvider.notifier);

      final result = await viewModel.updatePaymentStatus(
        orderId: 'order123',
        status: 'paid',
      );

      expect(result, true);
      expect(viewModel.state.status, PaymentStatus.success);
    });

    test('should return false when update fails', () async {
      when(() => mockRepository.updatePaymentStatus(
        orderId: any(named: 'orderId'),
        status: any(named: 'status'),
        transactionId: any(named: 'transactionId'),
      )).thenAnswer((_) async => const Left(ApiFailure(message: 'Update failed')));

      createContainer();
      viewModel = container.read(paymentViewModelProvider.notifier);

      final result = await viewModel.updatePaymentStatus(
        orderId: 'order123',
        status: 'paid',
      );

      expect(result, false);
      expect(viewModel.state.status, PaymentStatus.failure);
    });
  });

  group('reset', () {
    test('should reset state to initial', () {
      createContainer();
      viewModel = container.read(paymentViewModelProvider.notifier);
      viewModel.initPaymentData(tCartItems, 100.0);

      viewModel.reset();

      expect(viewModel.state.status, PaymentStatus.initial);
      expect(viewModel.state.cartItems, isEmpty);
      expect(viewModel.state.totalAmount, 0);
    });
  });
}
