import 'package:flutter/material.dart';

class ContainerReusable extends StatelessWidget {
  final double radius;
  final Color color;
  final double? width;
  final double? height;
  final double horizontalMargin;
  final double verticalMargin;
  final double? padding;
  final Widget child;

  const ContainerReusable({
    super.key,
    required this.radius,
    required this.color,
    this.width,
    this.height,
    required this.horizontalMargin,
    required this.verticalMargin,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 0),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }
}
