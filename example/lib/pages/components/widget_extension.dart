import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension WidgetModifier on Widget {
  Padding padding([EdgeInsetsGeometry value = const EdgeInsets.all(16)]) {
    return Padding(
      padding: value,
      child: this,
    );
  }

  DecoratedBox background(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
      ),
      child: this,
    );
  }

  ClipRRect cornerRadius(BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
      child: this,
    );
  }

  Align align([AlignmentGeometry alignment = Alignment.center]) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  ElevatedButton elevatedButton({required VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: this,
    );
  }

  SizedBox sizeBox({double? width, double? height}) {
    return SizedBox(
      child: this,
      width: width,
      height: height,
    );
  }

  Center center() {
    return Center(child: this);
  }

  SafeArea safeArea() {
    return SafeArea(child: this);
  }

  /// Parameter ex:
  ///```dart
  ///border: Border.all(
  ///  color: Colors.black54,
  ///  widtgh: 2.0,
  ///)
  ///
  ///borderRadius: BorderRadius.circular(15),
  ///```
  Container borderRadius(
      {Color? color,
      DecorationImage? image,
      BoxBorder? border,
      BorderRadiusGeometry? borderRadius,
      BoxShape shape = BoxShape.rectangle}) {
    return Container(
      child: this,
      decoration: BoxDecoration(
        color: color,
        image: image,
        border: border,
        borderRadius: borderRadius,
        shape: shape,
      ),
    );
  }
}

extension ListWidgetModifier on List<Widget> {
  Row row({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      children: this,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  Column column({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      children: this,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  Stack stack({
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return Stack(
      children: this,
      alignment: alignment,
      fit: fit,
      clipBehavior: clipBehavior,
    );
  }
}

/// may use package: build_context 3.0.0
extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
}

/// Convenience widget
ClipOval buildCircle({
  required Widget child,
  required double all,
  required Color color,
}) =>
    ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
