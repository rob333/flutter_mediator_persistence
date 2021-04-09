import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mediator_persistence/mediator.dart';
import 'package:flutter_test/flutter_test.dart';

import 'list_test.dart';
import 'touch_cnt.dart';

void main() {
  group(
    'Rx persistent object test',
    () {
      test('scheduleMicrotask test', () {
        final list = <int>[];
        // print('len:${list.length}');
        scheduleMicrotask(() {
          // print('in microtask: len:${list.length}');
          assert(list.length == 10, 'scheduleMicrotask failed');
        });
        list.add(5);
        list.add(5);
        list.addAll([5, 1, 6, 3, 1, 6, 3, 5]);
      });

      testWidgets('Rx persist bool test', (WidgetTester tester) async {
        await initGlobalPersist();
        await tester.pumpWidget(
          TouchCntApp(),
        );

        final origAspectLen = globalAllAspects.length;

        const key = 'rxBoolTest';
        final prefs = getPersistStore();
        // Make sure store starts clean.
        if (prefs.containsKey(key)) await prefs.remove(key);
        final i = false.globalPersist(key);
        i.value = !i.value;
        expect(prefs.getBool(key), true);
        i.value = !i.value;
        expect(prefs.getBool(key), false);
        // Remove the key from store.
        i.remove();

        await tester.pump();
        // We add a `i` persistent watched variable.
        expect(globalAllAspects.length, origAspectLen + 1);

        // We change the `i` persistent watched variable, should notify an aspect.
        expect(globalFrameAspects.length, 1);
      });

      testWidgets('Rx persist string test', (WidgetTester tester) async {
        await initGlobalPersist();
        await tester.pumpWidget(
          TouchCntApp(),
        );

        final origAspectLen = globalAllAspects.length;

        const key = 'rxStringTest';
        final prefs = getPersistStore();
        // Make sure store starts clean.
        if (prefs.containsKey(key)) await prefs.remove(key);
        final i = ''.globalPersist(key);
        i.value += 'a';
        expect(prefs.getString(key), 'a');
        i.value += 'b';
        expect(prefs.getString(key), 'ab');
        // Remove the key from store.
        i.remove();

        await tester.pump();
        // We add a `i` persistent watched variable.
        expect(globalAllAspects.length, origAspectLen + 1);

        // We change the `i` persistent watched variable, should notify an aspect.
        expect(globalFrameAspects.length, 1);
      });

      testWidgets('Rx persist int test', (WidgetTester tester) async {
        await initGlobalPersist();
        await tester.pumpWidget(
          TouchCntApp(),
        );

        final origAspectLen = globalAllAspects.length;

        const key = 'rxIntTest';
        final prefs = getPersistStore();
        // Make sure store starts clean.
        if (prefs.containsKey(key)) await prefs.remove(key);
        final i = 0.globalPersist(key);
        i.value += 1;
        expect(prefs.getInt(key), 1);
        i.value += 5;
        expect(prefs.getInt(key), 6);
        // Remove the key from store.
        i.remove();

        await tester.pump();
        // We add a `i` persistent watched variable.
        expect(globalAllAspects.length, origAspectLen + 1);

        // We change the `i` persistent watched variable, should notify an aspect.
        expect(globalFrameAspects.length, 1);
      });

      testWidgets('Rx persist double test', (WidgetTester tester) async {
        await initGlobalPersist();
        await tester.pumpWidget(
          TouchCntApp(),
        );

        final origAspectLen = globalAllAspects.length;

        const key = 'rxDoubleTest';
        final prefs = getPersistStore();
        // Make sure store starts clean.
        if (prefs.containsKey(key)) await prefs.remove(key);
        final i = 0.0.globalPersist(key);
        i.value += 0.1;
        expect(prefs.getDouble(key), 0.1);
        i.value += 0.1;
        expect(prefs.getDouble(key), 0.2);
        // Remove the key from store.
        i.remove();

        await tester.pump();
        // We add a `i` persistent watched variable.
        expect(globalAllAspects.length, origAspectLen + 1);

        // We change the `i` persistent watched variable, should notify an aspect.
        expect(globalFrameAspects.length, 1);
      });

      // Disabled, take long time to execute on github action.
      // TimeoutException after 0:10:00.000000: Test timed out after 10 minutes.
      // testWidgets('Rx persist StringList test', (WidgetTester tester) async {
      //   await initGlobalPersist();
      //   await tester.pumpWidget(
      //     TouchCntApp(),
      //   );

      //   final origAspectLen = globalAllAspects.length;

      //   const key = 'rxStringListTest';
      //   final prefs = getPersistStore();
      //   // Make sure store starts clean.
      //   if (prefs.containsKey(key)) await prefs.remove(key);
      //   final i = <String>[].globalPersist(key);
      //   i.ob.add('value1');
      //   await tester.pump();
      //   expect(i.ob.length, 1);
      //   i.ob.add('value2');
      //   await tester.pump();
      //   expect(i.ob.length, 2);
      //   // Remove the key from store.
      //   i.remove();
      //   await tester.pump();
      //   expect(i.ob.length, 0);

      //   await tester.pump();
      //   // We add a `i` persistent watched variable.
      //   expect(globalAllAspects.length, origAspectLen + 1);

      //   // We change the `i` persistent watched variable, should notify an aspect.
      //   expect(globalFrameAspects.length, 1);
      // });
    },
  );

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
