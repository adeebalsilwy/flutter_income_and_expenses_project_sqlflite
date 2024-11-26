import 'package:flutter/material.dart';

class TextReusable extends StatelessWidget {
  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight? fontWeight;

  const TextReusable({
    super.key,
    required this.text,
    this.color = Colors.black,
    required this.fontSize,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
