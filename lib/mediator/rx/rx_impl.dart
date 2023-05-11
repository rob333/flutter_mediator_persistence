import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../assert.dart';
import '../global.dart';
import '../host.dart';

/// A proxy object class, for variables to turn into a watched one.
class RxImpl<T> {
  /// Constructor: add self to the static rx container
  /// and sholud use [setPub] to set the [Pub] when the model initialized.
  RxImpl(this._value) {
    // RxImpl(T initial) : _value = initial {
    ///
    /// variables and constructor calling sequence:
    /// 1. Model inline variables ->
    /// 2. Pub inline variables ->
    /// 3. Pub constructor ->
    /// 4. Model constructor

    _initRxTag();
  }

  T _value; // the underlying value with template type T

  //* region member variables
  final rxAspects = <Object>{}; // aspects attached to this rx variable
  bool _isNullBroadcast = false; // if this rx variable is broadcasting

  /// static aspects and the flag of if enabled
  static Iterable<Object>? stateWidgetAspects;
  static bool stateWidgetAspectsFlag = false;

  /// enable auto add static aspects to aspects of rx - by getter
  static void enableCollectAspect(Iterable<Object>? widgetAspects) {
    stateWidgetAspects = widgetAspects;
    stateWidgetAspectsFlag = true;
  }

  /// disable auto add static aspects to aspects of rx - by getter
  static void disableCollectAspect() {
    stateWidgetAspects = null;
    stateWidgetAspectsFlag = false;
  }
  //! endregion

  //* region static rx auto aspect section
  static int rxTagCounter = 0;

  /// Return the next unique system tag.
  static int _nextRxTag() {
    assert(ifTagMaximum(rxTagCounter));
    // return numToString128(rxTagCounter++); // As of Mediator v2.1.2+3 changes to `int` tag.
    return rxTagCounter++;
  }

  static bool stateRxAutoAspectFlag = false;
  static List<Object> stateRxAutoAspects = [];

  static void enableRxAutoAspect() => stateRxAutoAspectFlag = true;
  static void disableRxAutoAspect() => stateRxAutoAspectFlag = false;
  static List<Object> getRxAutoAspects() => stateRxAutoAspects;
  static void clearRxAutoAspects() => stateRxAutoAspects.clear();
  // get RxAutoAspects and disable RxAutoAspectFlag
  static List<Object> getAndDisableRxAutoAspect() {
    stateRxAutoAspectFlag = false;
    return stateRxAutoAspects;
  }

  /// disable RxAutoAspectFlag And clear RxAutoAspects
  static void disableAndClearRxAutoAspect() {
    stateRxAutoAspectFlag = false;
    stateRxAutoAspects.clear();
  }
  //! endregion

  /// Getter:
  ///
  /// Return the value of the underlying object.
  ///
  /// The value used inside the consume widget will cause the widget
  /// to rebuild when updating; or use
  ///
  ///     watchedVar.consume(() => widget)
  /// to `touch()` the watched variable itself first and then `globalConsume(() => widget)`.
  T get value {
    // if rx automatic aspect is enabled. (precede over state rx aspect)
    if (stateRxAutoAspectFlag == true) {
      touch(); // Touch to activate rx automatic aspect management.
      //
    } else if (stateWidgetAspectsFlag == true) {
      if (stateWidgetAspects != null) {
        rxAspects.addAll(stateWidgetAspects!);
      } else {
        _isNullBroadcast = true;
      }
    }

    return _value;
  }

  /// Setter:
  ///
  /// Set the value of the underlying object.
  ///
  /// Update to the value will notify the host to rebuild;
  /// or the underlying object would be a class, then use
  ///
  /// `watchedVar.ob.updateMethod(...)` to notify the host to rebuild.
  ///
  ///     watchedVar.ob = watchedVar.notify() and then return the underlying object
  set value(T value) {
    if (_value != value) {
      _value = value;
      publishRxAspects();
      _keepPersist();
    }
  }

  /// Dummy function,
  /// to let the descendent class to implement the persistent function.
  void _keepPersist() {}

  /// Notify the host to rebuild related consume widget and then return
  /// the underlying object.
  ///
  /// Suitable for class type [_value], like List, Map, Set, and class.
  ///
  /// ex. var is a int List: `<int>[]`,
  ///
  ///     var.ob.add(1); // to notify the host to rebuild related consume widget.
  T get ob {
    publishRxAspects();
    _keepPersist();
    return _value;
  }

  /// Activate automatic aspect management for this watched variable.
  void touch() {
    // add the _tag to the rx automatic aspect list,
    // for later getRxAutoAspects() to register to host
    stateRxAutoAspects.addAll(rxAspects);
  }

  /// Add an unique system `tag` to this Rx object.
  void _initRxTag() {
    final tag = _nextRxTag();
    // Add the tag to the Rx Aspects list.
    rxAspects.add(tag);
    // Add the tag to the registered aspects of the `Host`.
    globalAllAspects.add(tag);
  }

  /// Create a consume widget and connect with the watched variable.
  /// The consume widget will rebuild whenever the watched variable updates.
  ///
  /// e.g.
  ///
  ///     watchedVar.consume(() => widget)
  /// is to `touch()` the watched variable itself first and then
  /// `globalConsume(() => widget)`.
  Widget consume(Widget Function() create, {Key? key}) {
    wrapFn() {
      touch();
      return create();
    }

    return globalConsume(wrapFn, key: key);
  }

  /// Add [aspects] to the Rx aspects.
  /// param aspects:
  ///   Iterable: add [aspects] to the rx aspects
  ///   null: broadcast to the model
  /// RxImpl: add [(aspects as RxImpl).rxAspects] to the rx aspects
  ///       : add `aspects` to the rx aspects
  void addRxAspects([Object? aspects]) {
    if (aspects is Iterable<Object>) {
      rxAspects.addAll(aspects);
    } else if (aspects == null) {
      _isNullBroadcast = true;
    } else if (aspects is RxImpl) {
      rxAspects.addAll(aspects.rxAspects);
    } else {
      rxAspects.add(aspects);
    }
  }

  /// Remove [aspects] from the Rx aspects.
  /// param aspects:
  ///   Iterable: remove [aspects] from the rx aspects
  ///   null: don't broadcast to the model
  /// RxImpl: remove [(aspects as RxImpl).rxAspects] from the rx aspects
  ///       : remove `aspects` from the rx aspects
  void removeRxAspects([Object? aspects]) {
    if (aspects is Iterable<Object>) {
      rxAspects.removeAll(aspects);
    } else if (aspects == null) {
      _isNullBroadcast = false;
    } else if (aspects is RxImpl) {
      rxAspects.removeAll(aspects.rxAspects);
    } else {
      rxAspects.remove(aspects);
    }
  }

  /// Retain [aspects] in the Rx aspects.
  /// param aspects:
  ///   Iterable: retain rx aspects in the [aspects]
  ///     RxImpl: retain rx aspects in the [(aspects as RxImpl).rxAspects]
  ///           : retain rx aspects in the `aspects`
  void retainRxAspects(Object aspects) {
    if (aspects is Iterable) {
      rxAspects.retainAll(aspects);
    } else if (aspects is RxImpl) {
      rxAspects.retainAll(aspects.rxAspects);
    } else {
      rxAspects.retainWhere((element) => element == aspects);
    }
  }

  /// Clear all the Rx aspects.
  void clearRxAspects() => rxAspects.clear();

  // /// Copy info from another Rx variable.
  // void copyInfo(RxImpl<T> other) {
  //   _tag.addAll(other._tag);
  //   rxAspects.addAll(other.rxAspects);
  // }

  /// Publish Rx aspects to the host.
  void publishRxAspects() {
    if (_isNullBroadcast) {
      return globalPublish();
    } else if (rxAspects.isNotEmpty) {
      return globalPublish(rxAspects);
    }
  }

  /// Synonym of `publishRxAspects()`.
  void notify() => publishRxAspects();

  //* override method
  @override
  String toString() => _value.toString();
}

/// Rx<T> class
class Rx<T> extends RxImpl<T> {
  /// Constructor: With `initial` as the initial value.
  Rx(T initial) : super(initial);
}

/// Extension for all others type to Rx object.
extension RxExtension<T> on T {
  /// Returns a `Rx` instace with [this] `T` as the initial value.
  Rx<T> get rx => Rx<T>(this);
}

///
/// Persistent section ///
///
late SharedPreferences _sharedPreferences;
bool _isPersistenceInit = false;

/// Initial the persistent storage.
///
/// Use `await initGlobalPersist();` in the `main()` before `runApp()`.
///
/// ex.
/// ```dart
/// Future<void> main() async {
///   await initGlobalPersist();
///   runApp(
///     globalHost(child: MyApp())
///   );
/// }
/// ```
Future<void> initGlobalPersist() async {
  if (_isPersistenceInit == false) {
    WidgetsFlutterBinding
        .ensureInitialized(); // To make sure SharedPreferences works.

    _sharedPreferences = await SharedPreferences.getInstance();
    _isPersistenceInit = true;
  }
}

/// Return the backend persistent storage, a `SharedPreferences` instance.
///
/// ex. `final prefs = getPersistStore();`
SharedPreferences getPersistStore() => _sharedPreferences;

//

class RxPersistBase<T> extends RxImpl<T> {
  RxPersistBase(this._persistKey, this._defaultValue) : super(_defaultValue);

  /// The key for the persistent storage of this Rx persistent object.
  final String _persistKey;
  final T _defaultValue;

  /// Remove the key/value of the persistent watched variable from
  /// the persistent storage, and set it's value to the default.
  ///
  /// **Won't notify the host to rebuild.**
  void remove() {
    if (_sharedPreferences.containsKey(_persistKey)) {
      // omit await
      _sharedPreferences.remove(_persistKey);
    }
    _value = _defaultValue;
  }

  /// Store the [input] to the persistent watched variable.
  ///
  /// **Won't notify the host to rebuild.**
  void store(T input) {
    _value = input;
    _keepPersist();
  }
}

/// Rx persistent class for `bool` Type.
class RxPersistBool extends RxPersistBase<bool> {
  /// Rx persistent class, with the persistent key of [_persistKey].
  ///
  /// Default value to [initial] if the persistent storage returns null.
  RxPersistBool(String key, [bool initial = false])
      : assert(_isPersistenceInit,
            'Persistent storage did not initialize, please use initGlobalPersist() in main()'),
        super(key, initial) {
    _value = _sharedPreferences.getBool(_persistKey) ?? initial;
  }

  /// Called by the setter of [RxImpl]
  /// to put the [_value] to the persistent storage.
  @override
  void _keepPersist() {
    // omit await
    _sharedPreferences.setBool(_persistKey, _value);
  }
}

/// Extension for bool type to Rx persistent class.
extension RxPersistBoolExtension on bool {
  /// Returns a `RxPersistBool`, with the persistent key of [key].
  ///
  /// Default value to [this] if the persistent storage returns null.
  ///
  /// Usage: defaultBoolValue.globalPersist(key)
  ///
  /// ex.
  ///
  ///     final persistVar = false.globalPersist(key);
  RxPersistBool globalPersist(String key) {
    return RxPersistBool(key, this);
  }
}

/// Rx persistent class for `String` Type.
class RxPersistString extends RxPersistBase<String> {
  /// Rx persistent class, with the persistent key of [_persistKey].
  ///
  /// Default value to [initial] if the persistent storage returns null.
  RxPersistString(String key, [String initial = ''])
      : assert(_isPersistenceInit,
            'Persistent storage did not initialize, please use initGlobalPersist() in main()'),
        super(key, initial) {
    _value = _sharedPreferences.getString(_persistKey) ?? initial;
  }

  /// Called by the setter of [RxImpl]
  /// to put the [_value] to the persistent storage.
  @override
  void _keepPersist() {
    // omit await
    _sharedPreferences.setString(_persistKey, _value);
  }
}

/// Extension for String type to Rx persistent class.
extension RxPersistStringExtension on String {
  /// Returns a `RxPersistString`, with the persistent key of [key].
  ///
  /// Default value to [this] if the persistent storage returns null.
  ///
  /// Usage: defaultStringValue.globalPersist(key)
  ///
  /// ex.
  ///
  ///     final persistVar = ''.globalPersist(key);
  RxPersistString globalPersist(String key) {
    return RxPersistString(key, this);
  }
}

/// Rx persistent class for `int` Type.
class RxPersistInt extends RxPersistBase<int> {
  /// Rx persistent class, with the persistent key of [_persistKey].
  ///
  /// Default value to [initial] if the persistent storage returns null.
  RxPersistInt(String key, [int initial = 0])
      : assert(_isPersistenceInit,
            'Persistent storage did not initialize, please use initGlobalPersist() in main()'),
        super(key, initial) {
    _value = _sharedPreferences.getInt(_persistKey) ?? initial;
  }

  /// Called by the setter of [RxImpl]
  /// to put the [_value] to the persistent storage.
  @override
  void _keepPersist() {
    // omit await
    _sharedPreferences.setInt(_persistKey, _value);
  }
}

/// Extension for int type to Rx persistent class.
extension RxPersistIntExtension on int {
  /// Returns a `RxPersistInt`, with the persistent key of [key].
  ///
  /// Default value to [this] if the persistent storage returns null.
  ///
  /// Usage: defaultIntValue.globalPersist(key)
  ///
  /// ex.
  ///
  ///     final persistVar = 0.globalPersist(key);
  RxPersistInt globalPersist(String key) {
    return RxPersistInt(key, this);
  }
}

/// Rx persistent class for `double` Type.
class RxPersistDouble extends RxPersistBase<double> {
  /// Rx persistent class, with the persistent key of [_persistKey].
  ///
  /// Default value to [initial] if the persistent storage returns null.
  RxPersistDouble(String key, [double initial = 0.0])
      : assert(_isPersistenceInit,
            'Persistent storage did not initialize, please use initGlobalPersist() in main()'),
        super(key, initial) {
    _value = _sharedPreferences.getDouble(_persistKey) ?? initial;
  }

  /// Called by the setter of [RxImpl]
  /// to put the [_value] to the persistent storage.
  @override
  void _keepPersist() {
    // omit await
    _sharedPreferences.setDouble(_persistKey, _value);
  }
}

/// Extension for double type to Rx persistent class.
extension RxPersistDoubleExtension on double {
  /// Returns a `RxPersistDouble`, with the persistent key of [key].
  ///
  /// Default value to [this] if the persistent storage returns null.
  ///
  /// Usage: defaultDoubleValue.globalPersist(key)
  ///
  /// ex.
  ///
  ///     final persistVar = 0.0.globalPersist(key);
  RxPersistDouble globalPersist(String key) {
    return RxPersistDouble(key, this);
  }
}

/// Rx persistent class for `List<String>` Type.
class RxPersistStringList extends RxPersistBase<List<String>> {
  /// Rx persistent class, with the persistent key of [_persistKey].
  ///
  /// Default value to [initial] if the persistent storage returns null.
  RxPersistStringList(String key, List<String> initial)
      : assert(_isPersistenceInit,
            'Persistent storage did not initialize, please use initGlobalPersist() in main()'),
        // For collections, needs to clone the initial collection to the _default value.
        super(key, [...initial]) {
    _value = _sharedPreferences.getStringList(_persistKey) ?? initial;
  }

  /// Called by the setter of [RxImpl]
  /// to put the [_value] to the persistent storage.
  @override
  void _keepPersist() {
    scheduleMicrotask(() {
      // omit await
      _sharedPreferences.setStringList(_persistKey, _value);
    });
  }

  /// Override, to enclosure `super.remove` in `scheduleMicrotask`
  /// to make sure `remove` won't precede `ob.updateMethod`.
  @override
  void remove() {
    scheduleMicrotask(() {
      // omit await
      super.remove();
    });
  }

  /// Override, to enclosure `super.store` in `scheduleMicrotask`
  /// to make sure `store` won't precede `ob.updateMethod`.
  @override
  void store(List<String> input) {
    scheduleMicrotask(() {
      // omit await
      super.store(input);
    });
  }
}

/// Extension for List<String> type to Rx persistent class.
extension RxPersistStringListExtension on List<String> {
  /// Returns a `RxPersistStringList`, with the persistent key of [key].
  ///
  /// Default value to [this] if the persistent storage returns null.
  ///
  /// Usage: defaultStringListValue.globalPersist(key)
  ///
  /// ex.
  ///
  ///     final persistVar = <String>[].globalPersist(key);
  RxPersistStringList globalPersist(String key) {
    return RxPersistStringList(key, this);
  }
}

/// End of persistent section ///

// /// Encode a number into a string
// String numToString128(int value) {
//   /// ascii code:
//   /// 32: space /// 33: !  (first character except space)
//   /// 48: 0
//   /// 65: A  /// 90: Z
//   /// 97: a  /// 122
//   // const int charBase = 33;
//   //'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!"#%&()*+,-./:;<=>?@[\\]^_`{|}~€‚ƒ„…†‡ˆ‰Š‹ŒŽ‘’“”•–—˜™š›œžŸ¡¢£¤¥¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ';
//   const charBase =
//       '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!"#%&()*+,-./:;<=>?@[]^_`{|}~€‚ƒ„…†‡•–™¢£¤¥©®±µ¶º»¼½¾ÀÆÇÈÌÐÑÒ×ØÙÝÞßæç';
//   assert(charBase.length >= 128, 'numToString128 const charBase length < 128');

//   if (value == 0) {
//     return '#0';
//   }

//   var res = '#';

//   assert(value >= 0, 'numToString should provide positive value.');
//   // if (value < 0) {
//   //   value = -value;
//   //   res += '-';
//   // }

//   final list = <String>[];
//   while (value > 0) {
//     /// 64 group
//     // final remainder = value & 63;
//     // value = value >> 6; // == divide by 64

//     /// 128 group
//     final remainder = value & 127;
//     value = value >> 7; // == divide by 128
//     /// num to char, base on charBase
//     //final char = String.fromCharCode(remainder + charBase);
//     final char = charBase[remainder];
//     list.add(char);
//   }

//   for (var i = list.length - 1; i >= 0; i--) {
//     res += list[i];
//   }

//   return res;
// }
