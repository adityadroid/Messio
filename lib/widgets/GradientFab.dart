

import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';

class GradientFab extends StatelessWidget {
  const GradientFab({
    Key key,
    @required this.animation,
    @required this.vsync,
  }) : super(key: key);

  final Animation<double> animation;
  final TickerProvider vsync;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
        duration: Duration(milliseconds: 1000),
        curve: Curves.linear,
        vsync: vsync,
        child: ScaleTransition(
            scale: animation,
            child: FloatingActionButton(
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
                child: Icon(Icons.add),
              ),
              onPressed: () {},
            )));
  }
}
