import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/Bloc.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = 100;

  @override
  _ChatAppBarState createState() => _ChatAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _ChatAppBarState extends State<ChatAppBar> {
  String username = "";
  String name = "";
  Image image = Image.asset(Assets.user);
  ChatBloc chatBloc;

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// Text style for everything else

    return BlocListener<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (bc, state) {
          if (state is FetchedContactDetailsState) {
            print(state.user);
            name = state.user.name;
            username = state.user.username;
            image = Image.network(state.user.photoUrl);
          }
        },
        child: Material(
            child: Container(
                decoration:  BoxDecoration(boxShadow: [
                  //adds a shadow to the appbar
                   BoxShadow(
                      color: Colors.grey, blurRadius: 2.0, spreadRadius: 0.1)
                ]),
                child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    color: Palette.primaryBackgroundColor,
                    child: Row(children: <Widget>[
                      Expanded(
                          //we're dividing the appbar into 7 : 3 ratio. 7 is for content and 3 is for the display picture.
                          flex: 7,
                          child: Center(
                              child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                  flex: 7,
                                  child: Container(
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Center(
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.attach_file,
                                                    color:
                                                        Palette.secondaryColor,
                                                  ),
                                                  onPressed: () => {}))),
                                      Expanded(
                                          flex: 6,
                                          child: Container(child:
                                              BlocBuilder<ChatBloc, ChatState>(
                                                  builder: (context, state) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(name,
                                                    style: Styles.textHeading),
                                                Text(username,
                                                    style: Styles.text)
                                              ],
                                            );
                                          }))),
                                    ],
                                  ))),
                              //second row containing the buttons for media
                              Expanded(
                                  flex: 3,
                                  child: Container(
                                      padding: EdgeInsets.fromLTRB(20, 5, 5, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Photos',
                                            style: Styles.text,
                                          ),
                                          VerticalDivider(
                                            width: 30,
                                            color: Palette.primaryTextColor,
                                          ),
                                          Text(
                                            'Videos',
                                            style: Styles.text,
                                          ),
                                          VerticalDivider(
                                            width: 30,
                                            color: Palette.primaryTextColor,
                                          ),
                                          Text('Files', style: Styles.text)
                                        ],
                                      ))),
                            ],
                          ))),
                      //This is the display picture
                      Expanded(
                          flex: 3,
                          child: Container(child: Center(child:
                              BlocBuilder<ChatBloc, ChatState>(
                                  builder: (context, state) {
                            return CircleAvatar(
                              radius: 30,
                              backgroundImage: image.image,
                            );
                          })))),
                    ])))));
  }
}
