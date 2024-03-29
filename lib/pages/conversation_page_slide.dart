import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/bloc.dart';
import 'package:messio/blocs/config/bloc.dart';
import 'package:messio/config/constants.dart';
import 'package:messio/models/chat.dart';
import 'package:messio/models/contact.dart';
import 'package:messio/utils/shared_objects.dart';
import 'package:messio/widgets/bottom_sheet_fixed.dart';
import 'package:messio/widgets/input_widget.dart';
import '../widgets/conversation_bottom_sheet.dart';
import 'conversation_page.dart';

class ConversationPageSlide extends StatefulWidget {
  final Contact startContact;

  @override
  _ConversationPageSlideState createState() =>
      _ConversationPageSlideState(startContact);

  const ConversationPageSlide({this.startContact});
}

class _ConversationPageSlideState extends State<ConversationPageSlide>
    with SingleTickerProviderStateMixin {
  PageController pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Contact startContact;
  ChatBloc chatBloc;
  List<Chat> chatList = List();
  bool isFirstLaunch = true;
  bool configMessagePeek = true;
  _ConversationPageSlideState(this.startContact);

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    //  chatBloc.dispatch(FetchChatListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            body: Column(
                children: <Widget>[
                  BlocListener<ChatBloc, ChatState>(
                      bloc: chatBloc,
                      listener: (bc, state) {
                        if (isFirstLaunch && chatList.isNotEmpty) {
                          isFirstLaunch = false;
                          for (int i = 0; i < chatList.length; i++) {
                            if (startContact.username == chatList[i].username) {
                              BlocProvider.of<ChatBloc>(context)
                                  .add(PageChangedEvent(i, chatList[i]));
                              pageController.jumpToPage(i);
                            }
                          }
                        }
                      },
                      child: Expanded(child: BlocBuilder<ChatBloc, ChatState>(
                        builder: (context, state) {
                          if (state is FetchedChatListState)
                            chatList = state.chatList;
                          return PageView.builder(
                              controller: pageController,
                              itemCount: chatList.length,
                              onPageChanged: (index) =>
                                  BlocProvider.of<ChatBloc>(context).add(
                                      PageChangedEvent(index, chatList[index])),
                              itemBuilder: (bc, index) =>
                                  ConversationPage(chat:chatList[index]));
                        },
                      ))),
                  BlocBuilder<ConfigBloc,ConfigState>(
                    builder: (context, state) {
                      if(state is UnConfigState)
                        configMessagePeek = SharedObjects.prefs.getBool(Constants.configMessagePeek);
                      if(state is ConfigChangeState)
                        if(state.key == Constants.configMessagePeek) configMessagePeek = state.value;
                      return GestureDetector(
                              child: InputWidget(),
                              onPanUpdate: (details) {
                                if(!configMessagePeek)
                                  return;
                                if (details.delta.dy < 100) {
                                showModalBottomSheetApp(context: context, builder: (context)=>ConversationBottomSheet());
                                }
                              });
                    }
                  )
                ],
              ),
            ));
  }
}
