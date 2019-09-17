import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';
import 'package:intl/intl.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/models/Message.dart';

class ChatItemWidget extends StatelessWidget {
  final Message message;

  const ChatItemWidget(this.message);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (message.isSelf) {
      //This is the sent message. We'll later use data from firebase instead of index to determine the message is sent or received.
      if (message is TextMessage) {
        final TextMessage textMessage = message as TextMessage;
        return Container(
            child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text(
                   textMessage.text,
                  style: TextStyle(color: Palette.selfMessageColor),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(
                    color: Palette.selfMessageBackgroundColor,
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(right: 10.0),
              )
            ],
            mainAxisAlignment:
                MainAxisAlignment.end, // aligns the chatitem to right end
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm')
                    .format(DateTime.fromMillisecondsSinceEpoch(textMessage.timeStamp)),
                style: Styles.date,
              ),
              margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
            )
          ])
        ]));
      } else {
        return Container();
      }
    } else {
      // This is a received message
      if (message is TextMessage) {
        final TextMessage textMessage = message as TextMessage;
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                      textMessage.text,
                      style: TextStyle(color: Palette.otherMessageColor),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Palette.otherMessageBackgroundColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
                  )
                ],
              ),
              Container(
                child: Text(
                  DateFormat('dd MMM kk:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(textMessage.timeStamp)),
                  style: Styles.date,
                ),
                margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      } else {
        return Container();
      }
    }
  }
}
