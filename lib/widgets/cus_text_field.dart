import 'package:flutter/material.dart';

class CusTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool obscureText;
  final void Function(String) onChanged;
  final String labelText;
  final String errorText;

  const CusTextField({
    Key key,
    this.obscureText = false,
    this.controller,
    this.errorText,
    this.keyboardType,
    this.labelText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        errorText: errorText,
      ),
    );
  }
}
