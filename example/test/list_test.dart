import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mediator_persistence/mediator.dart';

// ignore: avoid_relative_lib_imports
import 'var.dart' show data, ListItem;

void main() {
  // for test to work with package that requires this line of code
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ListTestApp(),
  );
}

class ListTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return globalHost(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Mediator List Test',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: globalConsume(
        () => GridView.builder(
          itemCount: data.value.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? 5
                      : 10),
          itemBuilder: (context, index) {
            final item = data.value[index];
            return Card(
              color: item.color,
              child: GridTile(
                footer: Text(item.units.toString()),
                child: Text(item.item),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            //* Stet4A: Make an update to the watched variable.
            onPressed: () => updateListItem(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}

//* item data
const int MaxItems = 35;
const int MaxUnits = 100;
const List<String> itemNames = [
  'Pencil',
  'Binder',
  'Pen',
  'Desk',
  'Pen Set',
];
const List<Color> itemColors = [
  Colors.pink,
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.lightGreen,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

void updateListItem() {
  final units = Random().nextInt(MaxUnits) + 1;
  final itemIdx = Random().nextInt(itemNames.length);
  final itemName = itemNames[itemIdx];
  final color = itemColors[Random().nextInt(itemColors.length)];
  if (data.value.length >= MaxItems) data.value.clear();

  //* Step4: Make an update to the watched variable.
  //* watchedVar.ob = watchedVar.notify() and then return the underlying object
  data.ob.add(ListItem(itemName, units, color));
}
