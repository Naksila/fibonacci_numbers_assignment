import 'package:fibonacci_numbers_assignment/presentation/fibonacci_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FibonacciPage displays', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FibonacciPage(),
      ),
    );

    expect(find.text('Index: 0, Number: 0'), findsOneWidget);
    expect(find.text('Index: 1, Number: 1'), findsOneWidget);
  });

  testWidgets('FibonacciPage removes item onTap', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FibonacciPage(),
      ),
    );

    expect(find.text('Index: 0, Number: 0'), findsOneWidget);
    await tester.tap(find.text('Index: 0, Number: 0'));
    await tester.pump();

    expect(find.text('Index: 0, Number: 0'), findsNothing);
  });

  testWidgets('FibonacciPage shows bottom sheet', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FibonacciPage(),
      ),
    );

    await tester.tap(find.text('Index: 0, Number: 0'));
    await tester.pump();

    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets('FibonacciPage restores item from bottom sheet',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FibonacciPage(),
      ),
    );

    await tester.tap(find.text('Index: 0, Number: 0'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Number 0'));
    await tester.pumpAndSettle();

    expect(find.text('Index: 0, Number: 0'), findsOneWidget);
  });
}
