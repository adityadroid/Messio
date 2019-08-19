
import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';
import 'ConversationPage.dart';

class ConversationPageSlide extends StatefulWidget {

  @override
  _ConversationPageSlideState createState() => _ConversationPageSlideState();

 const ConversationPageSlide();
}

class _ConversationPageSlideState extends State<ConversationPageSlide> with SingleTickerProviderStateMixin {
  var controller;

  @override
  void initState() {
    controller = RubberAnimationController(
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return PageView(
      children: <Widget>[
        ConversationPage(),
        ConversationPage(),
        ConversationPage()
      ],
    );

  }
}
