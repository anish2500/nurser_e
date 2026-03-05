import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nurser_e/core/services/hive/hive_service.dart';
import 'package:nurser_e/core/services/storage/user_session_service.dart';
import 'package:nurser_e/features/favorites/data/datasources/favorite_datasource.dart';
import 'package:nurser_e/features/favorites/data/datasources/remote/favorite_remote_datasource.dart';
import 'package:nurser_e/features/favorites/data/models/favorite_api_model.dart';
import 'package:nurser_e/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Favorites Integration Tests', () {
    late SharedPreferences sharedPreferences;
    late HiveService hiveService;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      
      hiveService = HiveService();
      await hiveService.init();
    });

    Widget createFavoritesPage() {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          hiveServiceProvider.overrideWithValue(hiveService),
          favoriteRemoteDatasourceProvder.overrideWithValue(
            _MockFavoriteRemoteDatasource(),
          ),
        ],
        child: const MaterialApp(home: FavoritesScreen()),
      );
    }

    testWidgets('Favorites page should display scaffold', (tester) async {
      await tester.pumpWidget(createFavoritesPage());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Favorites page should display app bar with title', (tester) async {
      await tester.pumpWidget(createFavoritesPage());
      await tester.pumpAndSettle();

      expect(find.text('Favorites'), findsOneWidget);
    });

    testWidgets('Favorites page should display empty state when no favorites', (tester) async {
      await tester.pumpWidget(createFavoritesPage());
      await tester.pumpAndSettle();

      expect(find.text('No favorites yet'), findsOneWidget);
      expect(find.text('Add plants to your favorites'), findsOneWidget);
    });

    testWidgets('Favorites page should display empty heart icon', (tester) async {
      await tester.pumpWidget(createFavoritesPage());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('Favorites page should handle loading state', (tester) async {
      await tester.pumpWidget(createFavoritesPage());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

class _MockFavoriteRemoteDatasource implements IFavoritesRemoteDatasource {
  @override
  Future<FavoriteApiModel> getFavorites() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return FavoriteApiModel(plants: []);
  }

  @override
  Future<FavoriteApiModel> addToFavorites(String plantId) async {
    return FavoriteApiModel(plants: []);
  }

  @override
  Future<FavoriteApiModel> removeFromFavorites(String plantId) async {
    return FavoriteApiModel(plants: []);
  }

  @override
  Future<bool> checkIsFavorite(String plantId) async {
    return false;
  }
}
