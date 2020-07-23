import 'package:flutter/services.dart';

import 'layout_color.dart';
import 'package:flutter/material.dart';

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
  final List<TextInputFormatter> textInputFormatter;
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
    this.textInputFormatter,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      textInputAction: textInputAction,
      focusNode: focusNode,
      enabled: enabled,
      initialValue: initialValue,
      inputFormatters: textInputFormatter,
      onFieldSubmitted: (String text) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
      style: TextStyle(
        fontSize: 15,
        color: Colors.black87,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          )),
    );
  }
}
