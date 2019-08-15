import 'package:flutter/material.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 100;
  @override
  Widget build(BuildContext context) {
    var textHeading = TextStyle(color: Palette.primaryTextColor, fontSize: 20); // Text style for the name
    var textStyle = TextStyle(color: Palette.secondaryTextColor); // Text style for everything else

    double width = MediaQuery.of(context).size.width; // calculate the screen width
    return Material(
        child: Container(
            decoration: new BoxDecoration(boxShadow: [ //adds a shadow to the appbar
              new BoxShadow(
              color: Colors.black,
              blurRadius: 5.0,
            )]),
            child:  Container(
                color: Palette.primaryBackgroundColor,
                child: Row(children: <Widget>[
              Expanded( //we're dividing the appbar into 7 : 3 ratio. 7 is for content and 3 is for the display picture.
                  flex: 7,
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          height: 70 - (width * .06),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: Center(
                                      child: Icon(
                                    Icons.attach_file,
                                    color: Palette.secondaryColor,
                                  ))),
                              Expanded(
                                  flex: 6,
                                  child: Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Aditya Gurjar', style: textHeading),
                                      Text('@adityagurjar', style: textStyle)
                                    ],
                                  ))),
                            ],
                          )),
                      //second row containing the buttons for media
                      Container(
                          height: 23,
                          padding: EdgeInsets.fromLTRB(20, 5, 5, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Photos',
                                style: textStyle,
                              ),
                              VerticalDivider(
                                width: 30,
                                color: Palette.primaryTextColor,
                              ),
                              Text(
                                'Videos',
                                style: textStyle,
                              ),
                              VerticalDivider(
                                width: 30,
                                color: Palette.primaryTextColor,
                              ),
                              Text('Files', style: textStyle)
                            ],
                          )),
                    ],
                  ))),
                //This is the display picture
              Expanded(
                  flex: 3,
                  child: Container(
                      child: Center(
                          child: CircleAvatar(
                    radius: (80 - (width * .06)) / 2,
                    backgroundImage: Image.asset(
                      Assets.user,
                    ).image,
                  )))),
            ]))));
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
