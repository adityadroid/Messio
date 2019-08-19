import 'package:flutter/material.dart';

import 'Palette.dart';

class Styles{
  static TextStyle textHeading = TextStyle(
      color: Palette.primaryTextColor,
      fontSize: 20); // Text style for the name
  static TextStyle subHeading = TextStyle(
      color: Palette.primaryTextColor,
      fontSize: 14);
  static TextStyle text = TextStyle(
      color: Palette.secondaryTextColor);
  static TextStyle subText = TextStyle(
    color: Palette.greyColor);
  static TextStyle date = TextStyle(
      color: Palette.greyColor,
      fontSize: 12.0,
      fontStyle: FontStyle.normal);
}