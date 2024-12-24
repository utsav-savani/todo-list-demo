import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_firebase_demo/core/navigation/router.dart'; // Import your router configuration

void main() {
  group('Core Tests', () {
    testWidgets('App initializes successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router, // Pass the router configuration
        ),
      );
      await tester.pumpAndSettle(); // Allow asynchronous operations to complete
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
