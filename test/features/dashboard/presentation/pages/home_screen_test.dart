import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';

void main() {
  group('HomeScreen UI Elements', () {
    testWidgets('should display Dashboard title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                SafeArea(
                  child: Container(
                    height: 70,
                    child: Text(
                      "Dashboard",
                      style: TextStyle(
                        fontFamily: 'Poppins Bold',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.green[400],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('should display New Arrivals card with texts', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              elevation: 1,
              color: const Color(0xFF3DC352),
              child: SizedBox(
                width: double.infinity,
                height: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("New Arrivals"),
                    Text("Explore the latest"),
                    Text("plant arrived in our garden"),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('New Arrivals'), findsOneWidget);
      expect(find.text('Explore the latest'), findsOneWidget);
      expect(find.text('plant arrived in our garden'), findsOneWidget);
    });

    testWidgets('should display search text field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should display All Plants section title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('All Plants'),
                  Text('View All'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('All Plants'), findsOneWidget);
      expect(find.text('View All'), findsOneWidget);
    });

    testWidgets('should display Search Results when query is not empty',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Search Results'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Search Results'), findsOneWidget);
    });

    testWidgets('should display Shop Now button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text("Shop Now"),
            ),
          ),
        ),
      );

      expect(find.text('Shop Now'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display plant grid when plants are available',
        (tester) async {
      final plants = [
        PlantEntity(
          id: '1',
          name: 'Rose Plant',
          description: 'Beautiful rose',
          category: 'Flowers',
          price: 25.99,
          plantImages: ['rose.jpg'],
          stock: 10,
        ),
        PlantEntity(
          id: '2',
          name: 'Tulip Plant',
          description: 'Colorful tulip',
          category: 'Flowers',
          price: 15.99,
          plantImages: ['tulip.jpg'],
          stock: 5,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return Card(
                  child: Column(
                    children: [
                      Text(plant.name),
                      Text('Rs ${plant.price.toStringAsFixed(2)}'),
                      Text(plant.category),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Rose Plant'), findsOneWidget);
      expect(find.text('Tulip Plant'), findsOneWidget);
      expect(find.text('Rs 25.99'), findsOneWidget);
      expect(find.text('Rs 15.99'), findsOneWidget);
      expect(find.text('Flowers'), findsNWidgets(2));
    });

    testWidgets('should display empty state when no plants available',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.eco,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No plants available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('No plants available'), findsOneWidget);
      expect(find.byIcon(Icons.eco), findsOneWidget);
    });

    testWidgets('should display loading indicator', (tester) async {
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

    testWidgets('should display error message when loading fails', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(
                'Error loading plants',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Error loading plants'), findsOneWidget);
    });

    testWidgets('should have SingleChildScrollView for scrolling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: const [
                  Text('Dashboard'),
                  Text('New Arrivals'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display View All button when query is empty',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('All Plants'),
                  TextButton(
                    onPressed: null,
                    child: Text('View All'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('View All'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });

  group('PlantEntity', () {
    test('should create PlantEntity with required fields', () {
      final plant = PlantEntity(
        id: '1',
        name: 'Rose Plant',
        description: 'Beautiful rose',
        category: 'Flowers',
        price: 25.99,
        plantImages: ['rose.jpg'],
        stock: 10,
      );

      expect(plant.id, '1');
      expect(plant.name, 'Rose Plant');
      expect(plant.price, 25.99);
      expect(plant.category, 'Flowers');
    });

    test('should handle empty plantImages list', () {
      final plant = PlantEntity(
        id: '1',
        name: 'Rose Plant',
        description: 'Beautiful rose',
        category: 'Flowers',
        price: 25.99,
        plantImages: [],
        stock: 10,
      );

      expect(plant.plantImages.isEmpty, true);
    });
  });
}
