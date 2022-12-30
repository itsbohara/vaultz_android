import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/modules/cloud/FileMoreMenu.dart';
import 'package:vaultz/modules/cloud/FolderMoreMenu.dart';
import 'package:vaultz/modules/cloud/file.dart';
import 'package:vaultz/modules/trash/TrashMoreMenu.dart';
import 'package:vaultz/pages/cloud/directory/cloudFolderView.dart';
import 'package:vaultz/utils/date.dart';
import 'package:vaultz/utils/file.dart';

class TrashListView extends StatelessWidget {
  TrashListView({super.key, required this.folderID});

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
            itemBuilder: (context, index) {
              var folder = dir.folders[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 1),
                child: ListTile(
                    leading: SvgPicture.asset("assets/icons/ic_folder.svg"),
                    onTap: () {
                      // Get.toNamed('/folder-view', arguments: {
                      //   'id': folder.id,
                      //   'name': folder.name
                      // });
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => FolderViewPage(
                              folderID: folder.id, folderName: folder.name),
                        ),
                      )
                          .then((value) async {
                        if (dir.openedDirs.length > 0) {
                          dir.removeLastDir();
                          // dir.getTrashFolder(dir.openedDirs.last);
                          dir.getTrashRoot();
                        }
                      });
                      // Get.to(() => FolderViewPage(
                      //     folderID: folder.id,
                      //     folderName: folder.name));
                    },
                    title: Text(folder.name!),
                    subtitle: Text(
                        "Size: ${folder.size}, ${formateDate(folder.updatedAt!)}"),
                    trailing: IconButton(
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.centerRight,
                      icon: const Icon(Icons.more_vert_rounded),
                      onPressed: () => Get.bottomSheet(
                          TrashMoreMenu(folder: folder, isFolder: true)),
                    )),
              );
            }),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: dir.files.length,
            itemBuilder: (context, index) {
              var file = dir.files[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 1),
                child: ListTile(
                    leading: SvgPicture.asset(getIconAsset(file.mimetype)),
                    onTap: () => openFile(file),
                    title: Text(file.name!),
                    subtitle: Text(
                        "Size: ${formatBytes(file.size!)}, ${formateDate(file.updatedAt!)}"),
                    // trailing: Icon(Icons.more_vert_rounded),
                    // contentPadding: EdgeInsets.symmetric(vertical: 1),
                    trailing: IconButton(
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.centerRight,
                      icon: const Icon(Icons.more_vert_rounded),
                      onPressed: () =>
                          Get.bottomSheet(TrashMoreMenu(file: file)),
                    )),
              );
            }),
      ],
    );
  }
}
