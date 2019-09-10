

import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

class GradientFab extends StatelessWidget {
  const GradientFab({
    Key key,
    this.animation,
    this.vsync,
    this.elevation,
    @required this.child,
    @required this.onPressed,
  }) : super(key: key);

  final Animation<double> animation;
  final TickerProvider vsync;
  final VoidCallback onPressed;
  final Widget child;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    var fab =FloatingActionButton(
      elevation: elevation!=null?elevation:6,
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomRight,
                colors: [
                  Palette.gradientStartColor,
                  Palette.gradientEndColor
                ])),
        child: child,
      ),
      onPressed: onPressed,
    );
    return animation!=null?AnimatedSize(
        duration: Duration(milliseconds: 1000),
        curve: Curves.linear,
        vsync: vsync,
        child: ScaleTransition(
            scale: animation,
            child: fab)):fab;
  }
}
