import 'package:flutter/material.dart';

class FieldWidget extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool hasBorder;

  const FieldWidget({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: hasBorder
              ? const BorderSide(color: Colors.black, width: 1.5)
              : BorderSide.none, // si no hay borde, nada
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: hasBorder
              ? const BorderSide(color: Colors.black, width: 1.5)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: hasBorder
              ? const BorderSide(color: Colors.black, width: 2)
              : BorderSide.none,
        ),
      ),
    );
  }
}
