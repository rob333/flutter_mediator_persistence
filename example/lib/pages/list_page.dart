import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mediator_persistence/mediator.dart';

//* Step1: import the var.dart
import '/var.dart' show data, ListItem;
import 'components/widget_extension.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Demo')),
      //* Step3: Create a widget with `globalConsume` or `watchedVar.consume`
      //* to register the watched variable to the host to rebuild it when updating.
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
              ).padding(const EdgeInsets.all(7.0)),
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
