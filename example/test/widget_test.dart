import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'list_test.dart';
import 'touch_cnt.dart';

void main() {
  testWidgets('Counter increments Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      TouchCntApp(),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    // debugDumpApp();
  });

  testWidgets('List Test', (WidgetTester tester) async {
    await tester.pumpWidget(ListTestApp());

    // Verify that list starts empty.
    expect(find.byType(GridTile), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that list item incremented.
    expect(find.byType(GridTile), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that list item incremented.
    expect(find.byType(GridTile), findsNWidgets(2));
  });
}
