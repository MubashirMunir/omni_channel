
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        /// Left Divider
        const Expanded(
          child: Divider(
            thickness: 1,
          ),
        ),

        /// Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
           style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        /// Right Divider
        const Expanded(
          child: Divider(
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
