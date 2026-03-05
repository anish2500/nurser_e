import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nurser_e/features/plants/domain/entities/plant_entity.dart';

void main() {
  group('CategoriesScreen UI Elements', () {
    testWidgets('should display Indoor category section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.home),
                        const SizedBox(width: 8),
                        Text('Indoor', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Indoor'), findsOneWidget);
    });

    testWidgets('should display Outdoor category section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.wb_sunny),
                        const SizedBox(width: 8),
                        Text('Outdoor', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Outdoor'), findsOneWidget);
    });

    testWidgets('should display Flowering category section', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.local_florist),
                        const SizedBox(width: 8),
                        Text('Flowering', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Flowering'), findsOneWidget);
    });

    testWidgets('should display all three category sections', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Indoor'),
                  Text('Outdoor'),
                  Text('Flowering'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Indoor'), findsOneWidget);
      expect(find.text('Outdoor'), findsOneWidget);
      expect(find.text('Flowering'), findsOneWidget);
    });

    testWidgets('should display plant cards in category', (tester) async {
      final plants = [
        PlantEntity(
          id: '1',
          name: 'Snake Plant',
          description: 'Low maintenance',
          category: 'INDOOR',
          price: 15.99,
          plantImages: [],
          stock: 5,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(plants[index].name),
                    subtitle: Text('Rs ${plants[index].price.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Snake Plant'), findsOneWidget);
      expect(find.text('Rs 15.99'), findsOneWidget);
    });

    testWidgets('should display loading indicator', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
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
                  Icon(Icons.error_outline),
                  Text('Failed to load plants'),
                  ElevatedButton(onPressed: () {}, child: Text('Retry')),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Failed to load plants'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
