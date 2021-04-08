import 'package:flutter/foundation.dart';

/// Assert if obj exists, otherwise throw error message.
bool shouldExists(Object? obj, String errmsg) {
  if (obj == null) throw FlutterError(errmsg);
  return true;
}

/// Assert if obj not exists, otherwise throw error message.
bool shouldNull(Object? obj, String errmsg) {
  if (obj != null) throw FlutterError(errmsg);
  return true;
}

/// Assert rx auto aspect is not empty, i.e. rx automatic aspect is actived.
bool ifRxAutoAspectEmpty(List<Object> rxAutoAspectList) {
  if (rxAutoAspectList.isEmpty)
    throw FlutterError(
        'Flutter Mediator Error: No watched variable found in the widget.\n'
        'Try using `watchedVar.consume` or `model.rxVar.touch()`.\n'
        'Or use at least one watched variable in the widget.');
  return true;
}

/// rx_impl: Assert tag not to exceed maximum.
bool ifTagMaximum(int rxTagCounter) {
  if (rxTagCounter == 0x7fffffffffffffff)
    throw FlutterError('Rx Tag exceeded maximum.');
  return true;
}
