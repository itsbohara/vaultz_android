import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vaultz/models/File.model.dart';
import 'package:vaultz/modules/cloud/FileMoreMenu.dart';
import 'package:vaultz/modules/cloud/file.dart';
import 'package:vaultz/utils/date.dart';
import 'package:vaultz/utils/file.dart';

class FileListItem extends StatelessWidget {
  FileListItem({super.key, required this.file});

  File file;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        leading: Stack(
          children: [
            SvgPicture.asset(getIconAsset(file.mimetype)),
            file.encrypted!
                ? Positioned(
                    bottom: 0,
                    child: Image.asset(
                      // "assets/lock.png",
                      file.locked! ? "assets/lock.png" : "assets/shield.png",
                      height: file.locked! ? 13 : 16,
                    ))
                : SizedBox(),
          ],
        ),
        onTap: () => openFile(file),
        title: Text(
          file.name!,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${formatBytes(file.size!)}, ${formateDate(file.updatedAt!)}",
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          // padding: EdgeInsets.all(0),
          // alignment: Alignment.centerRight,
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () => Get.bottomSheet(FileMoreMenu(file: file)),
        ),
        // contentPadding: EdgeInsets.symmetric(vertical: 1),
      ),
    );
  }
}
