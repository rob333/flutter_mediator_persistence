import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mediator_persistence/mediator.dart';

//* Login token from the REST server.
var loginToken = '';

const DefaultLocale = 'en';
//* Declare the persistent watched variable with `defaultVal.globalPersist('key')`
final locale = DefaultLocale.globalPersist('locale');

//* Declare the persistent watched variable with `defaultVal.globalPersist('key')`
final themeIdx = 1.globalPersist('themeIdx');

/// Change the locale, by `String`[countryCode]
/// and store the setting with SharedPreferences.
Future<void> changeLocale(BuildContext context, String countryCode) async {
  final loc = Locale(countryCode);
  await FlutterI18n.refresh(context, loc);
  //* Step4: Make an update to the watched variable.
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
