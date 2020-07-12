import 'package:flutter/material.dart';

class BarataoUtils {
  static SnackBar snackbar;
  static showMessage(String message, BuildContext context) {
    snackbar =
        SnackBar(content: Text(message), duration: new Duration(seconds: 2));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
