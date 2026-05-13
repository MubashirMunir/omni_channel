import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String title;

  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final FontStyle? fontStyle;
  final double? height;
  final TextOverflow? overflow;

  const TextWidget(
      this.title, {
        super.key,
        this.style,
        this.color,
        this.textAlign,
        this.fontSize,
        this.fontWeight,
        this.maxLines,
        this.fontStyle,
        this.height,
        this.overflow,
      });

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        style ??
            Theme.of(context).textTheme.labelMedium ??
            const TextStyle();

    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: baseStyle.copyWith(
        color: color ?? baseStyle.color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: height,
      ),
    );
  }
}