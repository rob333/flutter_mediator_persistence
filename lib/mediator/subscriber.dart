import 'package:flutter/widgets.dart';

import 'assert.dart';
import 'host.dart';
import 'rx/rx_impl.dart';

/// The consume widget class
///
/// for `globalConsumeAll()`, to register them
/// to the host with all the aspects which has been registered.
@immutable
class Subscriber extends StatelessWidget {
  /// Create a consume widget.
  ///
  /// [aspects] : register the aspects with the consume widget. This widget
  /// will rebuild whenever any aspect in the [aspects] is notified.
  ///
  /// [create] : create a child widget of this consume widget.
  const Subscriber({
    Key? key,
    this.aspects,
    required this.create,
  }) : super(key: key);

  final Object? aspects;
  final Widget Function() create;

  @override
  Widget build(BuildContext context) {
    /// with specific aspects from the parameter
    Iterable<Object>? widgetAspects;
    if (aspects is Iterable<Object>) {
      widgetAspects = aspects as Iterable<Object>;
    } else if (aspects != null) {
      widgetAspects = [aspects!];
    }

    // register widgetAspects to the host, and add to [regAspects]
    Host.register(context, aspects: widgetAspects);

    /// Collect aspects into Rx variable.
    // enable automatic add static rx aspects to rx aspects - by getter
    RxImpl.enableCollectAspect(widgetAspects);
    // any rx variable used inside the create method will automatically rebuild related widgets when updating
    final widget = create();
    // disable automatic add static rx aspects to rx aspects - by getter
    RxImpl.disableCollectAspect();
    return widget;
  }
}

/// The consume widget class with automatic aspect management.
@immutable
class SubscriberAuto extends StatelessWidget {
  /// Create a consume widget.
  ///
  /// Register to the host to rebuild when any of the watched variable value
  /// used inside this widget is updating; or use `watchedVar.consume` to
  /// `touch()` the watched variable first.
  ///
  /// [create] : create a child widget of this consume widget.
  const SubscriberAuto({
    Key? key,
    required this.create,
  }) : super(key: key);

  final Widget Function() create;

  @override
  Widget build(BuildContext context) {
    /// Collect which Rx variables used inside the create function.
    /// Then register the [rxAspects] from those Rx variables to the [globalHost].
    RxImpl.enableRxAutoAspect();
    final widget = create();
    final rxAutoAspectList = RxImpl.getAndDisableRxAutoAspect();

    assert(ifRxAutoAspectEmpty(rxAutoAspectList));

    Host.register(context, aspects: rxAutoAspectList);
    // addRegAspect automatically in the RxImpl getter

    RxImpl.clearRxAutoAspects();
    return widget;
  }
}
