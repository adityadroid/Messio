import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messio/blocs/chats/Bloc.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/config/Transitions.dart';
import 'package:messio/models/Chat.dart';
import 'package:messio/models/Contact.dart';
import 'package:messio/pages/AttachmentPage.dart';
import 'package:messio/utils/SharedObjects.dart';
import 'package:messio/widgets/GradientSnackBar.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height = 100;
  final Contact contact;
  final Chat chat;

  ChatAppBar({this.contact, this.chat});

  @override
  _ChatAppBarState createState() => _ChatAppBarState(this.contact, this.chat);

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _ChatAppBarState extends State<ChatAppBar> {
  ChatBloc chatBloc;
  Contact contact;
  Chat chat;
  String receivedUsername;
  String _username = "";
  String _name = "";
  ImageProvider _image = Image.asset(
    Assets.user,
  ).image;

  _ChatAppBarState(this.contact, this.chat);

  @override
  void initState() {
    chatBloc = BlocProvider.of<ChatBloc>(context);
    if (contact != null) {
      _name = contact.name;
      _username = contact.username;
      _image = CachedNetworkImageProvider(contact.photoUrl);
      chat = Chat(contact.username, contact.chatId);
    } else {
      _username = chat.username;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// Text style for everything else

    return BlocListener<ChatBloc, ChatState>(
      bloc: chatBloc,
      listener: (bc, state) {
        if (state is FetchedContactDetailsState) {
          print('Received State of Page');
          print(state.user);
          if (state.username == _username) {
            _name = state.user.name;
            _image = CachedNetworkImageProvider(state.user.photoUrl);
          }
        }
        if (state is PageChangedState) {
          print(state.index);
          print('$_name, $_username');
        }
      },
      child: Material(
          child: Container(
              decoration: BoxDecoration(boxShadow: [
                //adds a shadow to the appbar
                BoxShadow(
                    color: Theme.of(context).hintColor,
                    blurRadius: 2.0,
                    spreadRadius: 0.1)
              ]),
              child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  color: Theme.of(context).primaryColor,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 2,
                                        child: Center(
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.attach_file,
                                                ),
                                                onPressed: () =>
                                                    showAttachmentBottomSheet(
                                                        context)))),
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
                                              Text(_name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .title),
                                              Text("@" + _username,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle)
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
                                        GestureDetector(
                                          child: Text(
                                            'Photos',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          onTap: () => Navigator.push(
                                              context,
                                              SlideLeftRoute(
                                                  page: AttachmentPage(
                                                      this.contact.chatId,
                                                      FileType.IMAGE))),
                                        ),
                                        VerticalDivider(
                                          width: 30,
                                          color: Theme.of(context)
                                              .textTheme
                                              .button
                                              .color,
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            'Videos',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          onTap: () => Navigator.push(
                                              context,
                                              SlideLeftRoute(
                                                  page: AttachmentPage(
                                                      this.contact.chatId,
                                                      FileType.VIDEO))),
                                        ),
                                        VerticalDivider(
                                          width: 30,
                                          color: Theme.of(context)
                                              .textTheme
                                              .button
                                              .color,
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            'Files',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button,
                                          ),
                                          onTap: () => Navigator.push(
                                              context,
                                              SlideLeftRoute(
                                                  page: AttachmentPage(
                                                      this.contact.chatId,
                                                      FileType.ANY))),
                                        )
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
                            backgroundImage: _image,
                          );
                        })))),
                  ])))),
    );
  }

  showAttachmentBottomSheet(context) {
    showModalBottomSheet<Null>(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Theme.of(context).backgroundColor,
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.image),
                    title: Text('Image'),
                    onTap: () => showFilePicker(FileType.IMAGE)),
                ListTile(
                    leading: Icon(Icons.videocam),
                    title: Text('Video'),
                    onTap: () => showFilePicker(FileType.VIDEO)),
                ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text('File'),
                  onTap: () => showFilePicker(FileType.ANY),
                ),
              ],
            ),
          );
        });
  }

  showFilePicker(FileType fileType) async {
    File file;
    if (fileType == FileType.IMAGE && SharedObjects.prefs.getBool(Constants.configImageCompression))
      file = await ImagePicker.pickImage(
          source: ImageSource.gallery, imageQuality: 70);
    else
      file = await FilePicker.getFile(type: fileType);
    
    if (file == null) return;
    chatBloc.dispatch(SendAttachmentEvent(chat.chatId, file, fileType));
    Navigator.pop(context);
    GradientSnackBar.showMessage(context, 'Sending attachment..');
  }
}
