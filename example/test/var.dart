import 'package:flutter/widgets.dart';
import 'package:flutter_mediator_persistence/mediator.dart';
import 'package:shared_preferences/shared_preferences.dart';

//* Declare a global scope SharedPreferences.
late SharedPreferences prefs;

//* Step1A: Declare the watched variable with `globalWatch`.
final touchCount = globalWatch(0, tag: 'tagCount'); // main.dart

final data = globalWatch(<ListItem>[]); // list_page.dart

//* Step1B: Declare a persistent watched variable with `late Rx<Type>`
const DefaultLocale = 'en';
late Rx<String> locale; // local_page.dart

final opacityValue = globalWatch(0.0); // scroll_page.dart

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

/// Initialize the persistent watched variables
/// whose value is stored by the SharedPreferences.
Future<void>? initVars() async {
  // To make sure SharedPreferences works.
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  locale = globalWatch(prefs.getString('locale') ?? DefaultLocale);
}
