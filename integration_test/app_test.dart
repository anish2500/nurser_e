import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nurser_e/app/app.dart';
import 'package:nurser_e/core/services/hive/hive_service.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    late SharedPreferences sharedPreferences;
    late HiveService hiveService;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      
      hiveService = HiveService();
      await hiveService.init();
    });

    Widget createApp() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          hiveServiceProvider.overrideWithValue(hiveService),
        ],
        child: const App(),
      );
    }

    testWidgets('App should start with splash screen', (tester) async {
      await tester.pumpWidget(createApp());

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('App should navigate after splash delay', (tester) async {
      await tester.pumpWidget(createApp());

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
