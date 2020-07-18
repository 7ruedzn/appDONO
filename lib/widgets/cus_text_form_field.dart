import 'package:flutter/material.dart';

import 'layout_color.dart';

class CusTextFormField extends StatelessWidget {
  final bool obscureText;
  final void Function(String) onChanged;
  final String labelText;
  final String hintText;
  final String Function(String) validator;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final String initialValue;
  final bool enabled;
  CusTextFormField({
    @required this.labelText,
    this.obscureText = false,
    this.onChanged,
    @required this.controller,
    this.hintText,
    @required this.validator,
    @required this.keyboardType,
    this.focusNode,
    this.nextFocus,
    this.textInputAction,
    this.initialValue,
    this.enabled,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      textInputAction: textInputAction,
      focusNode: focusNode,
      enabled: enabled,
      onFieldSubmitted: (String text) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      style: TextStyle(
        fontSize: 25,
        color: LayoutColor.primaryColor[500],
      ),
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 25,
            color: LayoutColor.primaryColor,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
          )),
    );
  }
}
