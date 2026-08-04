import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagePreview extends StatefulWidget {
  final String imageUrl;

  const ImagePreview({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(widget.imageUrl),
          backgroundDecoration: BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
          heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrl),
        ),
      ),
    );
  }
}
