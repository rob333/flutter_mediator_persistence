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
  static int _nextRxTag() {
    assert(ifTagMaximum(rxTagCounter));
    // return numToString128(rxTagCounter++); // As of v2.1.2+3 changes to `int` tag.
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

  /// getter: Return the value of the underlying object.
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

  /// setter: Set the value of the underlying object.
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

  /// Notify the host to rebuild and then return the underlying object.
  /// Suitable for class type _value, like List, Map, Set, classes
  /// To inform the value to update.
  /// Like if the value type is a List, you can do `var.ob.add(1)` to notify the host to rebuild.
  /// Or, you can manually notify the host to rebuild by `var.value.add(1); var.notify();`.
  T get ob {
    publishRxAspects();
    _keepPersist();
    return _value;
  }

  /// Touch to activate rx automatic aspect management.
  void touch() {
    // add the _tag to the rx automatic aspect list,
    // for later getRxAutoAspects() to register to host
    stateRxAutoAspects.addAll(rxAspects);
  }

  /// Add an unique system `tag` to the Rx object.
  void _initRxTag() {
    final tag = _nextRxTag();
    // Add the tag to the Rx Aspects list.
    rxAspects.add(tag);
    // Add the tag to the registered aspects of the `Host`.
    globalAllAspects.add(tag);
  }

  /// A helper function to `touch()` itself first and then `globalConsume`.
  Widget consume(Widget Function() create, {Key? key}) {
    final wrapFn = () {
      touch();
      return create();
    };
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

  /// Alias of `publishRxAspects()`.
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

/// Helper for all others type to Rx object.
extension RxExtension<T> on T {
  /// Returns a `Rx` instace with [this] `T` as the initial value.
  Rx<T> get rx => Rx<T>(this);
}

///
/// Persistent variables ///
///
late SharedPreferences _sharedPreferences;
bool _isPersistenceInit = false;

/// Initialize the persistent store for the Rx persistent object.
/// ex. use `await globalPersistInit();` in the `main()` before `runApp()`.
Future<void> globalPersistInit() async {
  if (_isPersistenceInit == false) {
    WidgetsFlutterBinding
        .ensureInitialized(); // To make sure SharedPreferences works.

    _sharedPreferences = await SharedPreferences.getInstance();
    _isPersistenceInit = true;
  }
}
//

class RxPersistBase<T> extends RxImpl<T> {
  RxPersistBase(this._persistKey, this._defaultValue) : super(_defaultValue);

  /// The key for the persistent store of this Rx persistent object.
  final String _persistKey;
  final T _defaultValue;

  /// Remove the value from the persistent store with the key
  /// of this Rx persistent object and reset it's [_value] to
  /// the default value.
  /// ** Won't notify the host to rebuild.
  void remove() {
    _sharedPreferences.remove(_persistKey);
    _value = _defaultValue;
  }

  /// Update the [_value] with [input] of this Rx persistent object
  /// and store the value to the persistent store.
  /// ** Won't notify the host to rebuild.
  void store(T input) {
    // assert(false, 'Please override `storePersist` in the descendant class');
    _value = input;
    _keepPersist();
  }
}

/// Rx persistent class for `bool` Type.
class RxPersistBool extends RxPersistBase<bool> {
  /// Rx persistent class, with the key of [_persistKey].
  /// Default value to [initial] if the persistent store returns null.
  RxPersistBool(String key, [bool initial = false])
      : assert(_isPersistenceInit,
            'Persistent store did not initialize, please use globalPersistInit() in main()'),
        super(key, initial) {
    _value = _sharedPreferences.getBool(_persistKey) ?? initial;
  }

  /// Called by the setter of [RxImpl]
  /// to put the [_value] to the persistent store.
  @override
  void _keepPersist() {
    // omit await
    _sharedPreferences.setBool(_persistKey, _value);
  }
}

/// Extension for bool type to Rx persistent object.
extension RxPersistBoolExtension on bool {
  /// Returns a `RxPersistBool`, persistent with the key: [key].
  /// Default value to [this] if the persistent store returns null.
  /// Usage: defaultBoolValue.globalPersist(key)
  ///       `final watchedVar = 0.globalPersist(key)`
  RxPersistBool globalPersist(String key) {
    return RxPersistBool(key, this);
  }
}

/// Rx persistent class for `String` Type.
class RxPersistString extends RxPersistBase<String> {
  /// Rx persistent class, with the key of [_persistKey].
  /// Default value to [initial] if the persistent store returns null.
  RxPersistString(String key, [String initial = ''])
      : assert(_isPersistenceInit,
            'Persistent store did not initialize, please use globalPersistInit() in main()'),
        super(key, initial) {
    _value = _sharedPreferences.getString(_persistKey) ?? initial;
  }

  /// Called by the setter of [RxImpl]
  /// to put the [_value] to the persistent store.
  @override
  void _keepPersist() {
    // omit await
    _sharedPreferences.setString(_persistKey, _value);
  }
}

/// Extension for String type to Rx persistent object.
extension RxPersistStringExtension on String {
  /// Returns a `RxPersistString`, persistent with the key: [key].
  /// Default value to [this] if the persistent store returns null.
  /// Usage: defaultStringValue.globalPersist(key)
  ///       `final watchedVar = ''.globalPersist(key)`
  RxPersistString globalPersist(String key) {
    return RxPersistString(key, this);
  }
}

/// Rx persistent class for `int` Type.
class RxPersistInt extends RxPersistBase<int> {
  /// Rx persistent class, with the key of [_persistKey].
  /// Default value to [initial] if the persistent store returns null.
  RxPersistInt(String key, [int initial = 0])
      : assert(_isPersistenceInit,
            'Persistent store did not initialize, please use globalPersistInit() in main()'),
        super(key, initial) {
    _value = _sharedPreferences.getInt(_persistKey) ?? initial;
  }

  /// Called by the setter of [RxImpl]
  /// to put the [_value] to the persistent store.
  @override
  void _keepPersist() {
    // omit await
    _sharedPreferences.setInt(_persistKey, _value);
  }
}

/// Extension for int type to Rx persistent object.
extension RxPersistIntExtension on int {
  /// Returns a `RxPersistInt`, persistent with the key: [key].
  /// Default value to [this] if the persistent store returns null.
  /// Usage: defaultIntValue.globalPersist(key)
  ///       `final watchedVar = 0.globalPersist(key)`
  RxPersistInt globalPersist(String key) {
    return RxPersistInt(key, this);
  }
}

/// Rx persistent class for `double` Type.
class RxPersistDouble extends RxPersistBase<double> {
  /// Rx persistent class, with the key of [_persistKey].
  /// Default value to [initial] if the persistent store returns null.
  RxPersistDouble(String key, [double initial = 0.0])
      : assert(_isPersistenceInit,
            'Persistent store did not initialize, please use globalPersistInit() in main()'),
        super(key, initial) {
    _value = _sharedPreferences.getDouble(_persistKey) ?? initial;
  }

  /// Called by the setter of [RxImpl]
  /// to put the [_value] to the persistent store.
  @override
  void _keepPersist() {
    // omit await
    _sharedPreferences.setDouble(_persistKey, _value);
  }
}

/// Extension for double type to Rx persistent object.
extension RxPersistDoubleExtension on double {
  /// Returns a `RxPersistDouble`, persistent with the key: [key].
  /// Default value to [this] if the persistent store returns null.
  /// Usage: defaultDoubleValue.globalPersist(key)
  ///       `final watchedVar = 0.0.globalPersist(key)`
  RxPersistDouble globalPersist(String key) {
    return RxPersistDouble(key, this);
  }
}



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
