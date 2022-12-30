import 'package:get/get.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:vaultz/modals/verifyVaultzModal.dart';
import 'package:vaultz/models/File.model.dart' as VaultzFile;
import 'package:vaultz/fileViewer/FileViewer.dart';
import 'package:vaultz/utils/file.dart';

openFile(VaultzFile.File file) {
  if (file.locked!) {
    Get.dialog(VerifyVaultzModal(
      onVerify: () => doOpenFile(file),
    ));
    return;
  }
  doOpenFile(file);
}

doOpenFile(VaultzFile.File file) {
  if (file.mimetype!.split("/").length.isGreaterThan(0)) {
    var format = getFileFormat(file.name!.split(".").last);
    if (format == 'img') format = 'image';
    if (viewSupportedFileExts.contains(file.mimetype!.split("/")[0]) ||
        viewSupportedFileExts.contains(format)) {
      Get.to(() => FileViewer(file: file));
    } else {
      showCustomErrorSnackbar('File viewer not supported for this format');
    }
  }
}
