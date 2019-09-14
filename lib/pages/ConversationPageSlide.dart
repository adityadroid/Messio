import 'package:flutter/material.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/widgets/InputWidget.dart';
import 'package:rubber/rubber.dart';
import 'ConversationBottomSheet.dart';
import 'ConversationPage.dart';

class ConversationPageSlide extends StatefulWidget {
  final Contact startContact;

  @override
  _ConversationPageSlideState createState() =>
      _ConversationPageSlideState(startContact);

  const ConversationPageSlide({this.startContact});
}

class _ConversationPageSlideState extends State<ConversationPageSlide>
    with SingleTickerProviderStateMixin {
  var controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Contact startContact;

  _ConversationPageSlideState(this.startContact);

  @override
  void initState() {
    controller = RubberAnimationController(
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            body: Column(
              children: <Widget>[
                Expanded(child: PageView.builder(
                    itemCount: 500,
                    itemBuilder: (index, context) {
                  return ConversationPage();
                })),
                Container(
                    child: GestureDetector(
                        child: InputWidget(),
                        onPanUpdate: (details) {
                          if (details.delta.dy < 0) {
                            _scaffoldKey.currentState
                                .showBottomSheet<Null>((BuildContext context) {
                              return ConversationBottomSheet();
                            });
                          }
                        }))
              ],
            )));
  }
}
