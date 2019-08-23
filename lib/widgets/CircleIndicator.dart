import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

// ignore: must_be_immutable
class CircleIndicator extends StatefulWidget{
  bool isActive;
  CircleIndicator(this.isActive);

  @override
  _CircleIndicatorState createState() => _CircleIndicatorState();
}

class _CircleIndicatorState extends State<CircleIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: widget.isActive ? 12 : 8,
      width: widget.isActive ? 12 : 8,
      decoration: BoxDecoration(
          color:
          widget.isActive ? Palette.primaryColor : Palette.secondaryTextColorLight,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
