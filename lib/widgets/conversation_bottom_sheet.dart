import 'package:flutter/material.dart';
import 'package:messio/widgets/conversation_list_widget.dart';

import 'package:messio/widgets/navigation_pill_widget.dart';

class ConversationBottomSheet extends StatefulWidget {
  @override
  _ConversationBottomSheetState createState() =>
      _ConversationBottomSheetState();

  const ConversationBottomSheet();
}

class _ConversationBottomSheetState extends State<ConversationBottomSheet> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: ListView(children: <Widget>[
              GestureDetector(
                child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      NavigationPillWidget(),
                      Center(
                          child: Text('Messages', style: Theme.of(context).textTheme.headline6)),
                      SizedBox(
                        height: 20,
                      ),
                    ]),
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity > 50) {
                    Navigator.pop(context);
                  }
                },
              ),
              ConversationListWidget(),
            ])));
  }
}
