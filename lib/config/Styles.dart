import 'package:flutter/material.dart';

import 'Palette.dart';

class Styles{
  static TextStyle textHeading = TextStyle(
      color: Palette.primaryTextColor,
      fontSize: 20); // Text style for the name

  static TextStyle numberPickerHeading = TextStyle(
    fontSize: 30,
        color: Palette.primaryTextColorLight
  );
  static TextStyle textHeadingLight = TextStyle(
      color: Palette.primaryTextColorLight,
      fontSize: 20);
  static TextStyle question = TextStyle(
      color: Palette.primaryTextColor,
      fontSize: 16);
  static TextStyle questionLight = TextStyle(
      color: Palette.primaryTextColorLight,
      fontSize: 16);
  static TextStyle subHeading = TextStyle(
      color: Palette.primaryTextColor,
      fontSize: 14);
  static TextStyle subHeadingLight = TextStyle(
      color: Palette.primaryTextColorLight,
      fontSize: 14);
  static TextStyle hintText = TextStyle(
      color: Palette.hintTextColor
  );
  static TextStyle hintTextLight = TextStyle(
    color: Palette.hintTextColorLight
  );
  static TextStyle text = TextStyle(
    fontSize: 12,
      color: Palette.secondaryTextColor);
  static TextStyle textLight = TextStyle(
    color: Palette.secondaryTextColorLight
  );
  static TextStyle subText = TextStyle(
    color: Palette.greyColor);
  static TextStyle date = TextStyle(
      color: Palette.greyColor,
      fontSize: 12.0,
      fontStyle: FontStyle.normal);
  static TextStyle appBarTitle = TextStyle(
    color: Palette.primaryTextColor,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
}