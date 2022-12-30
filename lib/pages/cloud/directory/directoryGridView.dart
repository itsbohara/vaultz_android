import 'package:flutter/material.dart';

class DirectoryGridView extends StatefulWidget {
  DirectoryGridView({super.key, required this.folderID});

  String folderID;

  @override
  State<DirectoryGridView> createState() => _CloudGridViewState();
}

class _CloudGridViewState extends State<DirectoryGridView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Cloud Grid view he?"),
    );
  }
}
