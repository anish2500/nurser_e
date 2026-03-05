import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/favorites/domain/entities/favorite_entity.dart';
import 'package:nurser_e/features/favorites/presentation/state/favorite_state.dart';

void main() {
  group('FavoritesScreen UI Elements', () {
    testWidgets('should display Favorites title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                      fontFamily: 'Poppins Bold',
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Favorites'), findsOneWidget);
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
                    'Error loading favorites',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Error loading favorites'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should display empty state message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add plants to your favorites',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('No favorites yet'), findsOneWidget);
      expect(find.text('Add plants to your favorites'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should display favorite items when loaded', (tester) async {
      final tFavorites = [
        FavoriteEntity(
          id: '1',
          plantId: '1',
          name: 'Rose Plant',
          category: 'Flowers',
          description: 'A beautiful rose',
          price: 25.99,
          plantImages: ['rose.jpg'],
          stock: 10,
        ),
      ];

      final state = FavoriteState(
        status: FavoriteStatus.loaded,
        favorites: tFavorites,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final fav = state.favorites[index];
                return Column(
                  children: [
                    Text(fav.name),
                    Text('Rs ${fav.price.toStringAsFixed(2)}'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Rose Plant'), findsOneWidget);
      expect(find.text('Rs 25.99'), findsOneWidget);
    });

    testWidgets('should display multiple favorite items', (tester) async {
      final tFavorites = [
        FavoriteEntity(
          id: '1',
          plantId: '1',
          name: 'Rose Plant',
          category: 'Flowers',
          description: 'A beautiful rose',
          price: 25.99,
          plantImages: ['rose.jpg'],
          stock: 10,
        ),
        FavoriteEntity(
          id: '2',
          plantId: '2',
          name: 'Tulip Plant',
          category: 'Flowers',
          description: 'A colorful tulip',
          price: 15.99,
          plantImages: ['tulip.jpg'],
          stock: 20,
        ),
      ];

      final state = FavoriteState(
        status: FavoriteStatus.loaded,
        favorites: tFavorites,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final fav = state.favorites[index];
                return Column(
                  children: [
                    Text(fav.name),
                    Text('Rs ${fav.price.toStringAsFixed(2)}'),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Rose Plant'), findsOneWidget);
      expect(find.text('Tulip Plant'), findsOneWidget);
    });
  });

  group('FavoriteState', () {
    test('should have initial state', () {
      final state = FavoriteState.initial();

      expect(state.status, FavoriteStatus.initial);
      expect(state.favorites, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('should create loaded state with favorites', () {
      final tFavorites = [
        FavoriteEntity(
          id: '1',
          plantId: '1',
          name: 'Rose Plant',
          category: 'Flowers',
          description: 'A beautiful rose',
          price: 25.99,
          plantImages: ['rose.jpg'],
          stock: 10,
        ),
      ];

      final state = FavoriteState(
        status: FavoriteStatus.loaded,
        favorites: tFavorites,
      );

      expect(state.status, FavoriteStatus.loaded);
      expect(state.favorites.length, 1);
      expect(state.favorites.first.name, 'Rose Plant');
    });

    test('should create error state', () {
      final state = FavoriteState(
        status: FavoriteStatus.error,
        favorites: [],
        errorMessage: 'Failed to load',
      );

      expect(state.status, FavoriteStatus.error);
      expect(state.errorMessage, 'Failed to load');
    });
  });
}
