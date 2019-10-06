import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/Bloc.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Message.dart';

import 'ChatItemWidget.dart';

class ChatListWidget extends StatefulWidget {
  final Chat chat;

  ChatListWidget(this.chat);

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState(chat);
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final ScrollController listScrollController = ScrollController();
  List<Message> messages = List();
  final Chat chat;

  _ChatListWidgetState(this.chat);

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        BlocProvider.of<ChatBloc>(context)
            .dispatch(FetchPreviousMessagesEvent(this.chat,messages.last));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      print(state);
      if (state is FetchedMessagesState) {
        print('Received Messages');
        if (state.username == chat.username) {
          print(state.messages.length);
          print(state.isPrevious);
          if (state.isPrevious)
            messages.addAll(state.messages);
          else
            messages = state.messages;
        }
      }
      return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => ChatItemWidget(messages[index]),
        itemCount: messages.length,
        reverse: true,
        controller: listScrollController,
      );
    });
  }
}
