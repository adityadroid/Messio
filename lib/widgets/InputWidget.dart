import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/Bloc.dart';
import 'package:messio/config/Palette.dart';
class InputWidget extends StatefulWidget {
  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget>{
  final TextEditingController textEditingController = TextEditingController();
  ChatBloc chatBloc;
  bool showEmojiKeyboard = false;
  @override
  void initState() {
    chatBloc =  BlocProvider.of<ChatBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 60.0,
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Material(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.0),
                      child: IconButton(
                        icon: Icon(Icons.face),
                        color: Palette.accentColor,
                        onPressed: () =>chatBloc.dispatch(ToggleEmojiKeyboardEvent(!showEmojiKeyboard)),
                      ),
                    ),
                    color: Colors.white,
                  ),

                  // Text input
                  Flexible(
                    child: Material(
                        child: Container(
                          color: Palette.primaryBackgroundColor,
                      child: TextField(
                        style: TextStyle(
                            color: Palette.primaryTextColor, fontSize: 15.0),
                        controller: textEditingController,
                        autofocus: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type a message',
                          hintStyle: TextStyle(color: Palette.greyColor),
                        ),
                      ),
                    )),
                  ),

                  // Send Message Button
                  Material(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () => sendMessage(context),
                        color: Palette.accentColor,
                      ),
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
              BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
                showEmojiKeyboard = state is ToggleEmojiKeyboardState &&
                    state.showEmojiKeyboard;
                if (!showEmojiKeyboard) return Container();
                //hide keyboard
                FocusScope.of(context).requestFocus(new FocusNode());
                //create emojipicker
                return EmojiPicker(
                  rows: 4,
                  columns: 7,
                  bgColor: Palette.primaryBackgroundColor,
                  indicatorColor: Palette.accentColor,
                  onEmojiSelected: (emoji, category) {
                    textEditingController.text = textEditingController.text+ emoji.emoji;
                  },
                );
              })
            ],
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Palette.greyColor, width: 0.5)),
              color: Colors.white),
        ));
  }

  void sendMessage(context) {
       chatBloc.dispatch(SendTextMessageEvent(textEditingController.text));
    textEditingController.clear();
  }
}
