import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mediator_persistence/mediator.dart';

//* Login token from the REST server.
var loginToken = '';

const DefaultLocale = 'en';
//* Declare the persistent watched variable with `defaultVal.globalPersist('key')`
///    int: 0.globalPersist('intKey');
/// double: 0.0.globalPersist('doubleKey');
/// String: ''.globalPersist('StringKey');
///   bool: false.globalPersist('boolKey');
final locale = DefaultLocale.globalPersist('locale');
final themeIdx = 1.globalPersist('themeIdx');

//* Declare the watched variable with `globalWatch(initialValue)`.
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

/// Change the locale, by `String`[countryCode]
/// and store the setting with SharedPreferences.
Future<void> changeLocale(BuildContext context, String countryCode) async {
  final loc = Locale(countryCode);
  await FlutterI18n.refresh(context, loc);
  //* Step4: Make an update to the watched variable.
  //* The persistent watched variable will update the persistent value automatically.
  locale.value = countryCode;
}

/// Change the theme, by ThememData `int` [idx]
/// and store the setting with SharedPreferences.
void changeTheme(int idx) {
  idx = idx.clamp(0, 1);
  if (idx != themeIdx.value) {
    themeIdx.value = idx;
  }
}

/// Sign out from the REST server and clear the [loginToken].
void onSignOut(BuildContext context) {
  loginToken = '';
  Navigator.of(context).pushReplacementNamed('/');
}

extension StringI18n on String {
  /// String extension for i18n.
  String i18n(BuildContext context) {
    return FlutterI18n.translate(context, this);
  }

  /// String extension for i18n and `locale.consume` the widget.
  Widget ci18n(BuildContext context, {TextStyle? style}) {
    return locale.consume(
      () => Text(FlutterI18n.translate(context, this), style: style),
    );
  }
}

/// Get the screen width
double getScreenWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

/// Get the screen height
double getScreenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;
