import 'package:flutter/material.dart';

class TrashGridView extends StatefulWidget {
  TrashGridView({super.key, required this.folderID});

  String folderID;

  @override
  State<TrashGridView> createState() => _CloudGridViewState();
}

class _CloudGridViewState extends State<TrashGridView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Cloud Grid view he?"),
    );
  }
}
