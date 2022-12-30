import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/controllers/file.controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/models/File.model.dart' as VFile;
import 'package:vaultz/models/Folder.model.dart';
import 'package:vaultz/modules/cloud/file.dart';
import 'package:vaultz/utils/date.dart';
import 'package:vaultz/utils/file.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';

class TrashMoreMenu extends StatelessWidget {
  TrashMoreMenu({Key? key, this.file, this.folder, this.isFolder = false})
      : super(key: key);
  final fileController = Get.find<FileController>();
  final VFile.File? file;
  final Folder? folder;
  final bool isFolder;

  @override
  Widget build(BuildContext context) {
    // bool isDarkTheme = Get.isDarkMode;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    String trashedAt = isFolder ? folder!.updatedAt! : file!.updatedAt!;
    String name = isFolder ? folder!.name! : file!.name!;
    String id = isFolder ? folder!.id! : file!.id!;

    void handleRestore(ctx) {
      if (isFolder) {
        Get.find<DirectoryController>().restoreFolder(id);
      } else {
        Get.find<DirectoryController>().restoreFile(id);
      }
      Navigator.of(ctx).pop();
    }

    void handleDelete(ctx) {
      if (isFolder) {
        Get.find<DirectoryController>().deleteFolder(id);
      } else {
        Get.find<DirectoryController>().deleteFile(id);
      }
      Navigator.of(ctx).pop();
    }

    return Container(
      color: isDarkTheme ? Colors.black : Colors.white.withOpacity(0.96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 13, right: 13),
            leading: SizedBox.fromSize(
              size: const Size.fromRadius(25), // Image radius
              child: SvgPicture.asset(
                  getIconAsset(isFolder ? "folder" : file!.mimetype)),
            ),
            title: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: Text('Trashed at, ${formateDate(trashedAt)}'),
          ),
          const Divider(height: 2),
          ListTile(
            leading: const Icon(Icons.restore_rounded),
            title: const Text("Restore"),
            onTap: () => handleRestore(context),
          ),
          ListTile(
            leading: const Iconify(MaterialSymbols.delete_forever_rounded),
            title: const Text('Delete forever'),
            onTap: () {
              Navigator.pop(context);
              showDialog<void>(
                context: context,
                // barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete forever?'),
                    content: Text(
                        '"$name" will be deleted forever. Are you surce ?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Delete forever'),
                        onPressed: () => handleDelete(context),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
