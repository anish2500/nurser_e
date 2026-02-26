import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/cart/domain/entities/cart_item_entity.dart';
import 'package:nurser_e/features/cart/presentation/state/cart_state.dart';

void main() {
  group('CartScreen UI Elements', () {
    testWidgets('should display app bar with title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('My Cart')),
            body: const Center(child: Text('Cart Content')),
          ),
        ),
      );

      expect(find.text('My Cart'), findsOneWidget);
    });

    testWidgets('should display empty cart message when cart is empty',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_cart_outlined, size: 80),
                  SizedBox(height: 16),
                  Text('Your cart is empty'),
                  SizedBox(height: 8),
                  Text('Add plants to get started'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add plants to get started'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('should display loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: const CircularProgressIndicator(),
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
                children: const [
                  Icon(Icons.error_outline, size: 64),
                  SizedBox(height: 16),
                  Text('Failed to load cart'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: null,
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Failed to load cart'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display cart items with details', (tester) async {
      final tCartItems = [
        CartItemEntity(
          id: '1',
          plantId: 'plant1',
          plantName: 'Rose Plant',
          plantImage: 'rose.jpg',
          price: 25.99,
          quantity: 2,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: tCartItems.length,
              itemBuilder: (context, index) {
                final item = tCartItems[index];
                return ListTile(
                  title: Text(item.plantName),
                  subtitle: Text('Rs ${item.price.toStringAsFixed(2)}'),
                  trailing: Text('${item.quantity}'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Rose Plant'), findsOneWidget);
      expect(find.text('Rs 25.99'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should display quantity controls for cart items',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: const [
                Icon(Icons.remove_circle_outline),
                Text('2'),
                Icon(Icons.add_circle_outline),
                Icon(Icons.delete_outline),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should display checkout bar with total and button',
        (tester) async {
      final tCartItems = [
        CartItemEntity(
          id: '1',
          plantId: 'plant1',
          plantName: 'Rose Plant',
          plantImage: 'rose.jpg',
          price: 25.99,
          quantity: 2,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total (1 items)'),
                      Text('Rs 51.98'),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Total (1 items)'), findsOneWidget);
      expect(find.text('Rs 51.98'), findsOneWidget);
    });

    testWidgets('should calculate total amount correctly for multiple items',
        (tester) async {
      final tCartItems = [
        CartItemEntity(
          id: '1',
          plantId: 'plant1',
          plantName: 'Rose Plant',
          plantImage: 'rose.jpg',
          price: 25.50,
          quantity: 2,
        ),
        CartItemEntity(
          id: '2',
          plantId: 'plant2',
          plantName: 'Tulip Plant',
          plantImage: 'tulip.jpg',
          price: 15.00,
          quantity: 1,
        ),
      ];

      final state = CartState(
        status: CartStatus.loaded,
        items: tCartItems,
      );

      expect(state.totalItems, 3);
      expect(state.totalAmount, 66.00);
    });

    testWidgets('should display multiple cart items', (tester) async {
      final tCartItems = [
        CartItemEntity(
          id: '1',
          plantId: 'plant1',
          plantName: 'Rose Plant',
          plantImage: 'rose.jpg',
          price: 25.50,
          quantity: 2,
        ),
        CartItemEntity(
          id: '2',
          plantId: 'plant2',
          plantName: 'Tulip Plant',
          plantImage: 'tulip.jpg',
          price: 15.00,
          quantity: 1,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: tCartItems.length,
              itemBuilder: (context, index) {
                final item = tCartItems[index];
                return ListTile(
                  title: Text(item.plantName),
                  subtitle: Text('Rs ${item.price.toStringAsFixed(2)}'),
                  trailing: Text('${item.quantity}'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Rose Plant'), findsOneWidget);
      expect(find.text('Tulip Plant'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });
  });

  group('CartState', () {
    test('should calculate totalAmount correctly', () {
      final state = CartState(
        status: CartStatus.loaded,
        items: [
          CartItemEntity(
            id: '1',
            plantId: 'plant1',
            plantName: 'Rose Plant',
            plantImage: 'rose.jpg',
            price: 25.50,
            quantity: 2,
          ),
          CartItemEntity(
            id: '2',
            plantId: 'plant2',
            plantName: 'Tulip Plant',
            plantImage: 'tulip.jpg',
            price: 15.00,
            quantity: 1,
          ),
        ],
      );

      expect(state.totalAmount, 66.00);
    });

    test('should calculate totalItems correctly', () {
      final state = CartState(
        status: CartStatus.loaded,
        items: [
          CartItemEntity(
            id: '1',
            plantId: 'plant1',
            plantName: 'Rose Plant',
            plantImage: 'rose.jpg',
            price: 25.50,
            quantity: 2,
          ),
          CartItemEntity(
            id: '2',
            plantId: 'plant2',
            plantName: 'Tulip Plant',
            plantImage: 'tulip.jpg',
            price: 15.00,
            quantity: 1,
          ),
        ],
      );

      expect(state.totalItems, 3);
    });

    test('should have initial state with empty items', () {
      final state = CartState.initial();

      expect(state.status, CartStatus.initial);
      expect(state.items, isEmpty);
      expect(state.errorMessage, isNull);
    });
  });
}
