import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextWidget extends StatelessWidget {
  CustomTextWidget(
      {super.key,
      required this.text,
      this.isTitle = false,
      required this.fontSize,
      required this.color});
  final String text;
  final double fontSize;
  final Color color;
  bool isTitle;
  int maxLines = 10;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: isTitle ? FontWeight.bold : FontWeight.normal));
  }
}
