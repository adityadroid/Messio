import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/bloc.dart';
import 'package:messio/blocs/config/bloc.dart';
import 'package:messio/config/constants.dart';
import 'package:messio/models/contact.dart';
import 'package:messio/utils/shared_objects.dart';
import 'package:messio/widgets/bottom_sheet_fixed.dart';
import 'package:messio/widgets/input_widget.dart';
import '../widgets/conversation_bottom_sheet.dart';
import 'conversation_page.dart';

class SingleConversationPage extends StatefulWidget {
  final Contact contact;
  @override
  _SingleConversationPageState createState() =>
      _SingleConversationPageState(contact);

  const SingleConversationPage({this.contact});
}

class _SingleConversationPageState extends State<SingleConversationPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Contact contact;
  ChatBloc chatBloc;
  bool isFirstLaunch = true;
  bool configMessagePeek = true;
  _SingleConversationPageState(this.contact);

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    chatBloc.add(RegisterActiveChatEvent(contact.chatId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          body: Column(
            children: <Widget>[
             Expanded(child: ConversationPage(contact: contact,)),
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
