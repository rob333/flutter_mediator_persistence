import 'package:flutter/widgets.dart';
import 'package:flutter_mediator_persistence/mediator.dart';

//* Step1A: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0, tag: 'tagCount'); // main.dart

final data = globalWatch(<ListItem>[]); // list_page.dart

class ListItem {
  const ListItem(
    this.item,
    this.units,
    this.color,
  );

  final String item;
  final int units;
  final Color color;
}
