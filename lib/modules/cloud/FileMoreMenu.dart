import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/controllers/file.controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/modals/verifyVaultzModal.dart';
import 'package:vaultz/models/File.model.dart' as VFile;
import 'package:vaultz/modules/cloud/file.dart';
import 'package:vaultz/utils/date.dart';
import 'package:vaultz/utils/file.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/teenyicons.dart';

class FileMoreMenu extends StatelessWidget {
  FileMoreMenu({Key? key, this.file}) : super(key: key);
  final fileController = Get.find<FileController>();
  final dirController = Get.find<DirectoryController>();
  final VFile.File? file;

  handleLockUpdate() {
    if (file!.locked!) {
      Get.dialog(VerifyVaultzModal(
          onVerify: () =>
              dirController.updateFile(file!.id!, {"locked": false})));
    } else {
      dirController.updateFile(file!.id!, {"locked": true});
    }
  }

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
              size: const Size.fromRadius(25), // Image radius
              child: SvgPicture.asset(getIconAsset(file!.mimetype)),
            ),
            title: Text(
              file?.name ?? "File Name",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            subtitle: Text('Last modified: ${formateDate(file!.updatedAt!)} '),
          ),
          const Divider(height: 2),
          ListTile(
            leading: const Icon(Icons.play_circle_fill_outlined),
            title: const Text("View/Open File"),
            onTap: () {
              Navigator.pop(context);
              openFile(file!);
            },
          ),
          ListTile(
            leading: Iconify(file!.locked!
                ? Teenyicons.unlock_circle_outline
                : Teenyicons.lock_circle_outline),
            title: Text(file!.locked! ? "Disable Master Lock " : "Lock File"),
            onTap: () async {
              Navigator.pop(context);
              handleLockUpdate();
            },
          ),
          ListTile(
            leading:
                Iconify(MaterialSymbols.download_for_offline_outline_rounded),
            title: const Text("Download File"),
            onTap: () {
              // TODO download file
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Iconify(MaterialSymbols.delete_sweep_outline_rounded),
            title: const Text('Trash'),
            onTap: () {
              dirController.trashFile(file!.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
