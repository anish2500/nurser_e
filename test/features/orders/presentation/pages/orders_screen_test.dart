import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/orders/domain/entities/order_entity.dart';
import 'package:nurser_e/features/orders/presentation/state/order_state.dart';

void main() {
  group('OrdersScreen UI Elements', () {
    testWidgets('should display app bar with title My Orders', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text(
                'My Orders',
                style: TextStyle(
                  fontFamily: "Poppins Regular",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('My Orders'), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message with retry button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading orders',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Error loading orders'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display empty state with icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No orders yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start shopping to see your orders here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('No orders yet'), findsOneWidget);
      expect(find.byIcon(Icons.receipt_long), findsOneWidget);
    });

    testWidgets('should display order list when orders exist', (tester) async {
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: tOrders.length,
              itemBuilder: (context, index) {
                final order = tOrders[index];
                return ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Text('Rs ${order.totalAmount.toStringAsFixed(2)}'),
                  trailing: Text(order.orderStatus),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Order #order1'), findsOneWidget);
      expect(find.text('Rs 100.00'), findsOneWidget);
      expect(find.text('pending'), findsOneWidget);
    });

    testWidgets('should display refresh button when orders exist', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });

  group('OrderState', () {
    test('should have initial state', () {
      final state = OrderState.initial();

      expect(state.status, OrderStatus.initial);
      expect(state.orders, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('should calculate totalSpent correctly', () {
      final state = OrderState(
        status: OrderStatus.loaded,
        orders: [
          OrderEntity(
            id: '1',
            userId: 'user1',
            items: [],
            totalAmount: 50.0,
            paymentMethod: 'cash_on_delivery',
            orderStatus: 'pending',
            paymentStatus: 'pending',
            createdAt: DateTime.now(),
          ),
          OrderEntity(
            id: '2',
            userId: 'user1',
            items: [],
            totalAmount: 30.0,
            paymentMethod: 'cash_on_delivery',
            orderStatus: 'pending',
            paymentStatus: 'pending',
            createdAt: DateTime.now(),
          ),
        ],
      );

      expect(state.totalSpent, 80.0);
    });

    test('should calculate totalOrders correctly', () {
      final state = OrderState(
        status: OrderStatus.loaded,
        orders: [
          OrderEntity(
            id: '1',
            userId: 'user1',
            items: [],
            totalAmount: 50.0,
            paymentMethod: 'cash_on_delivery',
            orderStatus: 'pending',
            paymentStatus: 'pending',
            createdAt: DateTime.now(),
          ),
        ],
      );

      expect(state.totalOrders, 1);
    });
  });
}
