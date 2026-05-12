
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      this.title, {
        super.key,
        this.labelLarge = false,
        this.labelMedium = false,
        this.color,
        this.textAlign,
        this.fontSize,
        this.fontWeight,
        this.maxLines,
        this.fontStyle,
        this.height,
        this.overflow,
      });

  final String title;

  final bool labelLarge;
  final bool labelMedium;

  final Color? color;
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final FontStyle? fontStyle;
  final double? height;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    TextStyle baseStyle;

    if (labelLarge) {
      baseStyle = Theme.of(context).textTheme.labelLarge!;
    } else if (labelMedium) {
      baseStyle = Theme.of(context).textTheme.labelMedium!;
    } else {
      baseStyle = Theme.of(context).textTheme.labelSmall!;
    }

    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: baseStyle.copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: height,
        color: color,
      ),
    );
  }
}