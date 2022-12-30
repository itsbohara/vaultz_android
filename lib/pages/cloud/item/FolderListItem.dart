import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/models/Folder.model.dart';
import 'package:vaultz/modules/cloud/FolderMoreMenu.dart';
import 'package:vaultz/utils/date.dart';

class FolderListItem extends StatelessWidget {
  FolderListItem({super.key, required this.folder});

  Folder folder;

  final dir = Get.find<DirectoryController>();

  @override
  Widget build(BuildContext ctx) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
          leading: SvgPicture.asset("assets/icons/ic_folder.svg"),
          onTap: () => Navigator.pushNamed(ctx, '/folder-view',
                      arguments: {'id': folder.id, 'name': folder.name})
                  .then((value) {
                if (dir.openedDirs.length > 1) {
                  dir.removeLastDir();
                  dir.getFolder(dir.openedDirs.last);
                } else {
                  dir.getMyCloud();
                }
              }),
          title: Text(folder.name!),
          subtitle:
              Text("Size: ${folder.size}, ${formateDate(folder.updatedAt!)}"),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => Get.bottomSheet(FolderMoreMenu(folder: folder)),
          )),
    );
  }
}
