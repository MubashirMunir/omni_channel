import 'package:flutter/material.dart';

class InputFields extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final int maxLines;
  final TextInputType keyboardType;

  const InputFields({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      keyboardType: keyboardType,
      // style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        hintText: hint,
        // hintStyle: TextStyle(
        //   color: Colors.white.withOpacity(0.5),
        // ),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        // fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}