import 'package:flutter/material.dart';

class CusTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool obscureText;
  final void Function(String) onChanged;
  final String labelText;
  final String errorText;
  final String Function(String) validator;
  final String hint;

  const CusTextField(
      {Key key,
      this.obscureText = false,
      this.controller,
      this.errorText,
      this.keyboardType,
      this.labelText,
      this.onChanged,
      this.validator,
      this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint,
        labelText: labelText,
        errorText: errorText,
        alignLabelWithHint: true,
      ),
    );
  }
}
