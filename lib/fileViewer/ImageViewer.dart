import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({super.key, required this.file});

  File file;

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: FileImage(file),
    );
  }
}
