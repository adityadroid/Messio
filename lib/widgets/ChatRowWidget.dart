  import 'package:cached_network_image/cached_network_image.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:intl/intl.dart';
  import 'package:messio/blocs/config/Bloc.dart';
  import 'package:messio/config/Constants.dart';
  import 'package:messio/config/Palette.dart';
  import 'package:messio/config/Transitions.dart';
  import 'package:messio/models/Contact.dart';
  import 'package:messio/models/Conversation.dart';
  import 'package:messio/models/Message.dart';
  import 'package:messio/pages/ConversationPageSlide.dart';
  import 'package:messio/pages/SingleConversationPage.dart';
  import 'package:messio/utils/SharedObjects.dart';

  // ignore: must_be_immutable
  class ChatRowWidget extends StatelessWidget {
    final Conversation conversation;
    bool configMessagePaging = false;

    ChatRowWidget(this.conversation);

    @override
    Widget build(BuildContext context) {
      return BlocBuilder<ConfigBloc, ConfigState>(builder: (context, state) {
        if (state is UnConfigState)
          configMessagePaging =
              SharedObjects.prefs.getBool(Constants.configMessagePaging);
        if (state is ConfigChangeState) if (state.key ==
            Constants.configMessagePaging) configMessagePaging = state.value;
        return InkWell(
          onTap: () => Navigator.push(
              context,
              SlideLeftRoute(
                  page: configMessagePaging
                      ? ConversationPageSlide(
                          startContact: Contact.fromConversation(conversation))
                      : SingleConversationPage(
                          contact: Contact.fromConversation(conversation),
                        ))),
          child: Container(
              color: Theme.of(context).primaryColor,
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
                              backgroundImage: CachedNetworkImageProvider(
                                  conversation.user.photoUrl),
                            ),
                            width: 61.0,
                            height: 61.0,
                            padding: const EdgeInsets.all(1.0),
                            // borde width
                            decoration: new BoxDecoration(
                              color:
                                  Theme.of(context).accentColor, // border color
                              shape: BoxShape.circle,
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(conversation.user.name,
                                style: Theme.of(context).textTheme.body1),
                            messageContent(context, conversation.latestMessage)
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
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                  )
                ],
              )),
        );
      });
    }

    messageContent(context, Message latestMessage) {
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
                style: Theme.of(context).textTheme.caption,
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
              size: 10,
              color: Palette.greyColor,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              'Photo',
              style: Theme.of(context).textTheme.caption,
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
              size: 10,
              color: Palette.greyColor,
            ),
            Text(
              'Video',
              style: Theme.of(context).textTheme.caption,
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
              size: 10,
              color: Palette.greyColor,
            ),
            Text(
              'File',
              style: Theme.of(context).textTheme.caption,
            )
          ],
        );
      }
    }
  }
