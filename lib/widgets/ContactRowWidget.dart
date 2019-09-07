
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messio/config/Assets.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/config/Styles.dart';

class ContactRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Palette.primaryColor,
        padding: EdgeInsets.only(left: 30,top: 15,bottom: 15),
        child: Row(
          children: <Widget>[
            RichText(
              text:  TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style:  TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                   TextSpan(text: 'Aditya '),
                   TextSpan(text: 'Gurjar', style: new TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ));
  }
}
