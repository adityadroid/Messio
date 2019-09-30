import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/config/Transitions.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/models/Conversation.dart';
import 'package:messio/models/Message.dart';
import 'package:messio/pages/ConversationPageSlide.dart';

class ChatRowWidget extends StatelessWidget {
  final Conversation conversation;

  ChatRowWidget(this.conversation);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          SlideLeftRoute(
              page: ConversationPageSlide(
                  startContact: Contact.fromConversation(conversation)))),
      child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: Image.network(
                            conversation.user.photoUrl,
                          ).image,
                        ),
                        width: 61.0,
                        height: 61.0,
                        padding: const EdgeInsets.all(1.0), // borde width
                        decoration: new BoxDecoration(
                          color: Palette.accentColor, // border color
                          shape: BoxShape.circle,
                        )),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(conversation.user.name, style: Styles.subHeading),
                        messageContent(conversation.latestMessage)
                      ],
                    ))
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat('kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              conversation.latestMessage.timeStamp)),
                      style: Styles.date,
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  messageContent(Message latestMessage) {
    if (latestMessage is TextMessage)
      return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            latestMessage.isSelf
                ? Icon(
                    Icons.done,
                    size: 12,
                    color: Palette.greyColor,
                  )
                : Container(),
            SizedBox(
              width: 2,
            ),
            Text(
              latestMessage.text,
              style: Styles.subText,
            )
          ]);
    if (latestMessage is ImageMessage) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          latestMessage.isSelf
              ? Icon(
                  Icons.done,
                  size: 12,
                  color: Palette.greyColor,
                )
              : Container(),
          SizedBox(
            width: 2,
          ),
          Icon(
            Icons.camera_alt,
            size: 12,
            color: Palette.greyColor,
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            'Photo',
            style: Styles.subText,
          )
        ],
      );
    }
    if (latestMessage is VideoMessage) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          latestMessage.isSelf
              ? Icon(
                  Icons.done,
                  size: 12,
                  color: Palette.greyColor,
                )
              : Container(),
          SizedBox(
            width: 2,
          ),
          Icon(
            Icons.videocam,
            size: 12,
            color: Palette.greyColor,
          ),
          Text(
            'Video',
            style: Styles.subText,
          )
        ],
      );
    }
    if (latestMessage is FileMessage) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          latestMessage.isSelf
              ? Icon(
                  Icons.done,
                  size: 12,
                  color: Palette.greyColor,
                )
              : Container(),
          SizedBox(
            width: 2,
          ),
          Icon(
            Icons.attach_file,
            size: 12,
            color: Palette.greyColor,
          ),
          Text(
            'File',
            style: Styles.subText,
          )
        ],
      );
    }
  }
}
