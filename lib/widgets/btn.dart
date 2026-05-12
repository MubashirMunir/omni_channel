import 'package:elite_csr/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.height = 45,
    this.width,
    this.borderRadius = 8,
  });

  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,

        child: icon == null
            ? TextWidget(
          text,
labelLarge: true,        )
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon!,
            const SizedBox(width: 8),
            TextWidget(
              text,
              labelLarge: true,              ),
          ],
        ),
      ),
    );
  }
}
