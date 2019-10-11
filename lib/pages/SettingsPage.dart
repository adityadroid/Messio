import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messio/blocs/authentication/Bloc.dart';
import 'package:messio/blocs/config/Bloc.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Constants.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/utils/SharedObjects.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ConfigBloc configBloc;
  bool configDarkMode,
      configMessagesPeek,
      configMessagePaging,
      configImageCompression;

  //fields for the form
  File profileImageFile;
  ImageProvider profileImage;
  ImageProvider placeHolderImage = Image.asset(Assets.user).image;

  @override
  void initState() {
    super.initState();
    configBloc = BlocProvider.of<ConfigBloc>(context);
    configDarkMode = SharedObjects.prefs.getBool(Constants.configDarkMode);
    configMessagesPeek =
        SharedObjects.prefs.getBool(Constants.configMessagePeek);
    configMessagePaging =
        SharedObjects.prefs.getBool(Constants.configMessagePaging);
    configImageCompression =
        SharedObjects.prefs.getBool(Constants.configImageCompression);
    profileImage = CachedNetworkImageProvider(
        SharedObjects.prefs.getString(Constants.sessionProfilePictureUrl));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Container(
            height: height,
            width: width,
            alignment: AlignmentDirectional.topCenter,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                    colors: [
                  Palette.gradientStartColor,
                  Palette.gradientEndColor
                ])),
            child: FractionallySizedBox(
              heightFactor: 0.4,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                        child: GestureDetector(
                            onTap: pickImage,
                            child: BlocBuilder<ConfigBloc, ConfigState>(
                                builder: (context, state) {
                              if (state is ProfilePictureChangedState) {
                                profileImage = CachedNetworkImageProvider(
                                    state.profilePictureUrl);
                              }
                              if (state is UpdatingProfilePictureState) {
                                return Container(
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            backgroundColor: Theme.of(context)
                                                .primaryColor)));
                              }
                              return CircleAvatar(
                                radius: 50,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      color: Color.fromRGBO(0, 0, 0,
                                          0.3) // Specifies the background color and the opacity
                                      ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.camera,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      Text(
                                        'Change Profile\nPicture',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                backgroundImage: profileImage,
                              );
                            })),
                        width: 101.0,
                        height: 101.0,
                        padding: const EdgeInsets.all(.5),
                        // borde width
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                        )),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: FractionallySizedBox(
                heightFactor: .30,
                widthFactor: 1.0,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Container(
                    padding: EdgeInsets.only(right: 30, left: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                    child: Center(
                      child: BlocBuilder<ConfigBloc, ConfigState>(
                          builder: (context, state) {
                        if (state is ConfigChangeState) {
                          if (state.key == Constants.configDarkMode)
                            configDarkMode = state.value;
                          if (state.key == Constants.configMessagePeek)
                            configMessagesPeek = state.value;
                          if (state.key == Constants.configMessagePaging)
                            configMessagePaging = state.value;
                          if (state.key == Constants.configImageCompression)
                            configImageCompression = state.value;
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.photo_size_select_small,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      'Image Compression',
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: configImageCompression,
                                  onChanged: (value) => configBloc.dispatch(
                                      ConfigValueChanged(
                                          Constants.configImageCompression,
                                          value)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.remove_red_eye,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      'Messages Peek',
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    )
                                  ],
                                ),
                                Switch(
                                  value: configMessagesPeek,
                                  onChanged: (value) => configBloc.dispatch(
                                      ConfigValueChanged(
                                          Constants.configMessagePeek, value)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.compare_arrows,
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      'Message Paging',
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    )
                                  ],
                                ),
                                Switch(
                                  value: configMessagePaging,
                                  onChanged: (value) => configBloc.dispatch(
                                      ConfigValueChanged(
                                          Constants.configMessagePaging,
                                          value)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.wb_sunny,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        'Dark Mode',
                                        style:
                                            Theme.of(context).textTheme.subhead,
                                      )
                                    ]),
                                Switch(
                                  value: configDarkMode,
                                  onChanged: (value) => configBloc.dispatch(
                                      ConfigValueChanged(
                                          Constants.configDarkMode, value)),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                )),
          ),
          FractionallySizedBox(
            heightFactor: 1.0,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'SIGN OUT',
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: ()  => {BlocProvider.of<AuthenticationBloc>(context).dispatch(ClickedLogout()),
                      configBloc.dispatch(RestartApp())
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future pickImage() async {
    profileImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    configBloc.dispatch(UpdateProfilePicture(profileImageFile));
  }
}
