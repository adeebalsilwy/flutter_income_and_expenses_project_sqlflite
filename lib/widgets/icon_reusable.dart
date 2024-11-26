import 'package:flutter/material.dart';

class IconReusable extends StatelessWidget {
  final IconData icon;
  final double sizeIcon;
  final Color color;
  final Function()? callBackOnTap;

  const IconReusable({
    super.key,
    required this.icon,
    required this.sizeIcon,
    required this.color,
    this.callBackOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBackOnTap,
      child: Icon(
        icon,
        size: sizeIcon,
        color: color,
      ),
    );
  }
}
