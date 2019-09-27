import 'package:flutter/material.dart';

class ImageFullScreen extends StatelessWidget {
  final String url;
  final int index;
  ImageFullScreen(this.index,this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Hero(
          tag: 'AttachmentImage_$index',
          child: Image.network(url)),
    );
  }
}
