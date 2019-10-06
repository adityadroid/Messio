import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFullScreen extends StatelessWidget {
  final String url;
  final String tag;
  ImageFullScreen(this.tag,this.url);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Hero(
          tag: tag,
          child: CachedNetworkImage(imageUrl: url,)),
    );
  }
}
