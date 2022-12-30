import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/models/Folder.model.dart';
import 'package:vaultz/utils/date.dart';

import 'package:vaultz/utils/file.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';

class FolderMoreMenu extends StatelessWidget {
  FolderMoreMenu({Key? key, this.folder}) : super(key: key);
  final folderController = Get.find<DirectoryController>();
  final Folder? folder;

  @override
  Widget build(BuildContext context) {
    // bool isDarkTheme = Get.isDarkMode;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkTheme ? Colors.black : Colors.white.withOpacity(0.96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 13, right: 13),
            leading: SizedBox.fromSize(
              size: const Size.fromRadius(20), // Image radius
              child: SvgPicture.asset(getIconAsset("folder")),
            ),
            title: Text(
              folder?.name ?? "Folder Name",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: Text('Folder Size, ${formateDate(folder!.updatedAt!)}'),
          ),
          const Divider(height: 2),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text("Rename"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Iconify(MaterialSymbols.drive_file_move_outline_rounded),
            title: Text("Move"),
            onTap: () async {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading:
                Iconify(MaterialSymbols.download_for_offline_outline_rounded),
            title: const Text("Download"),
            onTap: () {
              // TODO download folder
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Iconify(MaterialSymbols.delete_sweep_outline_rounded),
            title: const Text('Trash'),
            onTap: () {
              folderController.trashFolder(folder!.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
