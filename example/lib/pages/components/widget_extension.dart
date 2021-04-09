import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension WidgetModifier on Widget {
  Widget padding([EdgeInsetsGeometry value = const EdgeInsets.all(16)]) {
    return Padding(
      padding: value,
      child: this,
    );
  }

  Widget background(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
      ),
      child: this,
    );
  }

  Widget cornerRadius(BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
      child: this,
    );
  }

  Widget align([AlignmentGeometry alignment = Alignment.center]) {
    return Align(
      alignment: alignment,
      child: this,
    );
  }

  Widget elevatedButton({required VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: this,
    );
  }

  Widget sizeBox({double? width, double? height}) {
    return SizedBox(
      child: this,
      width: width,
      height: height,
    );
  }

  Widget center() {
    return Center(child: this);
  }
}

extension ListWidgetModifier on List<Widget> {
  MultiChildRenderObjectWidget row({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Row(
      children: this,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  MultiChildRenderObjectWidget column({
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Column(
      children: this,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }

  MultiChildRenderObjectWidget stack({
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
