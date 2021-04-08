import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'host.dart';
import 'rx/rx_impl.dart';
import 'subscriber.dart';

/// Memory the watched variables, retrieved by [globalGet].
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
      if (_globalWatchedVar[T] == null)
        throw FlutterError(
            'Error: `globalGet` gets null. Type:$T does not exists.');
      return true;
    }());
    return _globalWatchedVar[T] as Rx<T>;
  }
  assert(() {
    if (_globalWatchedVar[tag] == null)
      throw FlutterError(
          'Error: `globalGet` gets null. Tag:$tag does not exists.');
    return true;
  }());
  return _globalWatchedVar[tag] as Rx;
}

/// A helper function to create a widget for the watched variable,
/// and register it to the host to rebuild the widget when updating.
SubscriberAuto globalConsume(Widget Function() create, {Key? key}) {
  return SubscriberAuto(key: key, create: create);
}

/// Broadcast to all the [globalConsume] widgets.
void globalBroadcast() => globalPublish();

/// Create a widget that will be rebuilt whenever any watched variables
/// changes are made.
Subscriber globalConsumeAll(Widget Function() create, {Key? key}) {
  return Subscriber(key: key, create: create);
}

/// [globalHost] : Create a [InheritedModel] To register the [Host] at
/// the top of the widget tree.
Widget globalHost({
  required Widget child,
}) {
  return Host(child: child);
}
