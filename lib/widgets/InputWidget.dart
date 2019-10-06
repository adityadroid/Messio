import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio/blocs/chats/Bloc.dart';
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
                        color: Theme.of(context).accentColor,
                        onPressed: () =>chatBloc.dispatch(ToggleEmojiKeyboardEvent(!showEmojiKeyboard)),
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),

                  // Text input
                  Flexible(
                    child: Material(
                        child: Container(
                          color: Theme.of(context).primaryColor,
                      child: TextField(
                        style: Theme.of(context).textTheme.body2,
                        controller: textEditingController,
                        autofocus: true,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type a message',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
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
                        color:Theme.of(context).accentColor,
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
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
                  bgColor: Theme.of(context).backgroundColor,
                  indicatorColor: Theme.of(context).accentColor,
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
                  Border(top: BorderSide(color: Theme.of(context).hintColor, width: 0.5)),
              color: Theme.of(context).primaryColor,
        ),
        ));
  }

  void sendMessage(context) {
    if(textEditingController.text.isEmpty)
      return;
    chatBloc.dispatch(SendTextMessageEvent(textEditingController.text));
    textEditingController.clear();
  }
}
