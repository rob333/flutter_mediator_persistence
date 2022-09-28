import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'host.dart';
import 'rx/rx_impl.dart';
import 'subscriber.dart';

/// Memory the watched variables, retrieved by `globalGet`.
final _globalWatchedVar = HashMap<Object, Object>();

/// Create a watched variable from the variable [v],
/// a proxy object of the Type of [Rx<T>]
Rx<T> globalWatch<T>(T v, {Object? tag}) {
  final rx = Rx(v);

  //* Check if the variable [Type] or the [tag] already exists
  if (tag == null) {
    if (!_globalWatchedVar.containsKey(T)) {
      _globalWatchedVar[T] = rx;
      // assert(() {
      //   print('Info: Global watched variable of Type: $T');
      //   return true;
      // }());
    }
    /*
    else {
      assert(() {
        print('Info: Global watched variable of Type: $T already exists.');
        print(
            'If the watched variable would be used across files, please use the [tag] parameter.');
        return true;
      }());
    }
    */
  } else {
    if (!_globalWatchedVar.containsKey(tag)) {
      _globalWatchedVar[tag] = rx;
    } else {
      throw FlutterError(
          'Error: Global watched variable of tag:$tag already exists.');
    }
  }

  return rx;
}

/// Retrieve the watched variable by [tag] or `Type` of [T]
Rx globalGet<T>({Object? tag}) {
  if (tag == null) {
    assert(() {
      if (_globalWatchedVar[T] == null) {
        throw FlutterError(
            'Error: `globalGet` gets null. Type:$T does not exists.');
      }
      return true;
    }());
    return _globalWatchedVar[T] as Rx<T>;
  }
  assert(() {
    if (_globalWatchedVar[tag] == null) {
      throw FlutterError(
          'Error: `globalGet` gets null. Tag:$tag does not exists.');
    }
    return true;
  }());
  return _globalWatchedVar[tag] as Rx;
}

/// Create a comsume widget for the watched variable
/// whose **value is used inside the widget**, and register to
/// the host to rebuild it when updating the watched variable.
///
/// If the value of the watched variable is not used inside the widget,
/// then use `watchedVar.consume` to create the consume widget to notify
/// the host to rebuild when updating the watched variable.
SubscriberAuto globalConsume(Widget Function() create, {Key? key}) {
  return SubscriberAuto(key: key, create: create);
}

/// Broadcast to all the consume widgets.
void globalBroadcast() => globalPublish();

/// Create a consume widget that will be rebuilt whenever
/// any watched variables changes are made.
Subscriber globalConsumeAll(Widget Function() create, {Key? key}) {
  return Subscriber(key: key, create: create);
}

/// Create a [InheritedModel] widget to listen to the watched variables
/// and rebuild related consume widgets when updating the watched variable.
///
/// Place at the top of the widget tree.
Widget globalHost({
  required Widget child,
}) {
  return Host(child: child);
}

/// Initial the most common case `main()`,
/// with the `[child]` widget, e.g.
///
/// ```dart
/// await initGlobal(MyApp())
/// ```
///  is the equivalent to
///
/// ```dart
/// await initGlobalPersist();
/// runApp(globalHost(child: MyApp()));
/// ```
///
/// ex.
/// ```dart
/// Future<void> main() async {
///  await initGlobal(MyApp());
/// }
/// ```
Future<void> initGlobal(Widget child) async {
  //* Initial the persistent storage.
  await initGlobalPersist();

  runApp(
    //* Create the host with `globalHost` at the top of the widget tree.
    globalHost(child: child),
  );
}
