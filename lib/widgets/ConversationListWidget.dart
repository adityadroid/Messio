import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/home/Bloc.dart';
import 'package:messio/models/Conversation.dart';
import 'ChatRowWidget.dart';

class ConversationListWidget extends StatefulWidget {
  @override
  State createState() => _ConversationListWidgetState();
}

class _ConversationListWidgetState extends State<ConversationListWidget> {
  HomeBloc homeBloc;
  List<Conversation> conversations = List();

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.dispatch(FetchHomeChatsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is FetchingHomeChatsState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is FetchedHomeChatsState) {
        conversations = state.conversations;
      }
      return ListView.builder(
        shrinkWrap: true,
          itemCount: conversations.length,
          itemBuilder: (context, index) => ChatRowWidget(conversations[index]));
    });
  }
}
