import 'package:flutter/material.dart';

import 'Palette.dart';
import 'Styles.dart';

class Decorations {

  static InputDecoration getInputDecoration({@required String hint, @required bool isPrimary}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: isPrimary?Styles.hintText:Styles.hintTextLight,
      contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: isPrimary ? Palette.secondaryColor : Palette.primaryColor,
            width: 0.1),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: isPrimary ? Palette.secondaryColor : Palette.primaryColor,
            width: 0.1),
      ),
    );
  }
}