import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';
import 'package:messio/blocs/home/Bloc.dart';
import 'package:messio/config/Transitions.dart';
import 'package:messio/models/Conversation.dart';
import 'package:messio/widgets/ChatRowWidget.dart';
import 'package:messio/widgets/GradientFab.dart';

import 'ContactListPage.dart';

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
    homeBloc.dispatch(FetchHomeChatsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Palette.primaryBackgroundColor,
            body: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Palette.primaryBackgroundColor,
                expandedHeight: 180.0,
                pinned: true,
                elevation: 0,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Chats", style: Styles.appBarTitle),
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
              child: Icon(Icons.contacts),
              onPressed: () => Navigator.push(
                  context, SlideLeftRoute(page: ContactListPage())),
            )));
  }
}
