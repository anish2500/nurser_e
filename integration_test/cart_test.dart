import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nurser_e/core/services/hive/hive_service.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/features/cart/presentation/pages/cart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cart Integration Tests', () {
    late SharedPreferences sharedPreferences;
    late HiveService hiveService;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      
      hiveService = HiveService();
      await hiveService.init();
    });

    Widget createCartPage() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          hiveServiceProvider.overrideWithValue(hiveService),
        ],
        child: const MaterialApp(home: CartScreen()),
      );
    }

    testWidgets('Cart page should display app bar with title', (tester) async {
      await tester.pumpWidget(createCartPage());
      await tester.pumpAndSettle();

      expect(find.text('My Cart'), findsOneWidget);
    });

    testWidgets('Cart page should display scaffold', (tester) async {
      await tester.pumpWidget(createCartPage());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Cart page should display empty cart when no items', (tester) async {
      await tester.pumpWidget(createCartPage());
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add plants to get started'), findsOneWidget);
    });

    testWidgets('Cart page should display empty cart icon', (tester) async {
      await tester.pumpWidget(createCartPage());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('Cart page should handle loading state', (tester) async {
      await tester.pumpWidget(createCartPage());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
