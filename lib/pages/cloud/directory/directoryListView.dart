import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/pages/cloud/item/FileListItem.dart';
import 'package:vaultz/pages/cloud/item/FolderListItem.dart';

class DirectoryListView extends StatelessWidget {
  DirectoryListView({super.key, required this.folderID});

  String folderID;

  DirectoryController dir = Get.find<DirectoryController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: dir.folders.length,
            itemBuilder: (context, index) =>
                FolderListItem(folder: dir.folders[index])),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: dir.files.length,
            itemBuilder: (context, index) =>
                FileListItem(file: dir.files[index])),
      ],
    );
  }
}
