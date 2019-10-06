import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/Bloc.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/widgets/BottomSheetFixed.dart';
import 'package:messio/widgets/InputWidget.dart';
import '../widgets/ConversationBottomSheet.dart';
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
  PageController pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Contact startContact;
  ChatBloc chatBloc;
  List<Chat> chatList = List();
  bool isFirstLaunch = true;
  var navigator;
  _ConversationPageSlideState(this.startContact);

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    //  chatBloc.dispatch(FetchChatListEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    navigator = Navigator.of(context);
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            body: Column(
                children: <Widget>[
                  BlocListener<ChatBloc, ChatState>(
                      bloc: chatBloc,
                      listener: (bc, state) {
                        print('ChatList $chatList');
                        if (isFirstLaunch && chatList.isNotEmpty) {
                          isFirstLaunch = false;
                          for (int i = 0; i < chatList.length; i++) {
                            if (startContact.username == chatList[i].username) {
                              BlocProvider.of<ChatBloc>(context)
                                  .dispatch(PageChangedEvent(i, chatList[i]));
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
                                  BlocProvider.of<ChatBloc>(context).dispatch(
                                      PageChangedEvent(index, chatList[index])),
                              itemBuilder: (bc, index) =>
                                  ConversationPage(chatList[index]));
                        },
                      ))),
                  Container(
                      child: GestureDetector(
                          child: InputWidget(),
                          onPanUpdate: (details) {
                            if (details.delta.dy < 100) {
                            showModalBottomSheetApp(context: context, builder: (context)=>ConversationBottomSheet());
                            }
                          }))
                ],
              ),
            ));
  }
}
