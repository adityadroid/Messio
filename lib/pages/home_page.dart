import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/home/bloc.dart';
import 'package:messio/config/transitions.dart';
import 'package:messio/models/conversation.dart';
import 'package:messio/pages/settings_page.dart';
import 'package:messio/widgets/chat_row_widget.dart';
import 'package:messio/widgets/gradient_fab.dart';

import 'contact_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc homeBloc;
  List<Conversation> conversations = List();

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(FetchHomeChatsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 180.0,
                pinned: true,
                elevation: 0,
                centerTitle: true,
                actions: <Widget>[
                 IconButton(
                   icon: Icon(Icons.settings),
                   color: Theme.of(context).accentColor,
                   onPressed: (){
                     Navigator.push(context, SlideLeftRoute(page:SettingsPage()));
                   },
                 )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Chats", style: Theme.of(context).textTheme.headline6),
                ),
              ),
              BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                if (state is FetchingHomeChatsState) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: (MediaQuery.of(context).size.height),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                } else if (state is FetchedHomeChatsState) {
                  conversations = state.conversations;
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => ChatRowWidget(conversations[index]),
                      childCount: conversations.length),
                );
              })
            ]),
            floatingActionButton: GradientFab(
              child: Icon(Icons.contacts, color: Theme.of(context).primaryColor,),
              onPressed: () => Navigator.push(
                  context, SlideLeftRoute(page: ContactListPage())),
            )));
  }
}
