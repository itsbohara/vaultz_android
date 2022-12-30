import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/pages/cloud/item/FileListItem.dart';
import 'package:vaultz/pages/cloud/item/FolderListItem.dart';

class CloudListView extends StatefulWidget {
  const CloudListView({super.key});

  @override
  State<CloudListView> createState() => _CloudListViewState();
}

class _CloudListViewState extends State<CloudListView> {
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
            itemBuilder: (ctx, index) =>
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
