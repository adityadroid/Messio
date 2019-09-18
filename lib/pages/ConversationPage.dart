import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/Bloc.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/widgets/ChatAppBar.dart';
import 'package:messio/widgets/ChatListWidget.dart';

class ConversationPage extends StatefulWidget {
  final Chat chat;

  @override
  _ConversationPageState createState() => _ConversationPageState(chat);

  const ConversationPage(this.chat);
}

class _ConversationPageState extends State<ConversationPage> {
  final Chat chat;

  _ConversationPageState(this.chat);
  ChatBloc chatBloc;
  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.dispatch(FetchConversationDetailsEvent(chat));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        return Column(children: <Widget>[
          Expanded(flex: 2, child: ChatAppBar()), // Custom app bar for chat screen
          Expanded(
              flex: 11,
              child: Container(
                color: Palette.chatBackgroundColor,
                child: ChatListWidget(),
              ))
        ]);
  }

}
