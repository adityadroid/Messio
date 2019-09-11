
import 'package:flutter/material.dart';
import 'package:messio/config/Palette.dart';
import 'package:messio/models/Contact.dart';

class ContactRowWidget extends StatelessWidget {
  const ContactRowWidget({
    Key key,
    @required this.contact,
  }) : super(key: key);
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Palette.primaryColor,
        child: Padding(
            padding: const EdgeInsets.only(
                left: 30, top: 10, bottom: 10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(text: contact.getFirstName()),
                  TextSpan(
                      text: ' ' + contact.getLastName(),
                      style:
                      TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )));
  }
}