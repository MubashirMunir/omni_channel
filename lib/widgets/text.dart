import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color? color;
  final TextAlign align;
  final int? maxLines;
  final TextOverflow overflow;

  const AppText(
      this.text, {
        Key? key,
        this.size = 14,
        this.weight = FontWeight.normal,
        this.color,
        this.align = TextAlign.start,
        this.maxLines,
        this.overflow = TextOverflow.ellipsis,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}
