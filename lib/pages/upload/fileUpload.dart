import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/file.controller.dart';
import 'package:vaultz/core/snackbar.dart';
import 'package:path/path.dart';
import 'package:vaultz/utils/file.dart';
import 'package:mime/mime.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  static const routeName = '/upload';

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  late BuildContext ctx;
  File? selectedFile;
  bool uploading = false;
  final fileController = Get.find<FileController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fileController.initVaultz();
    fileController.encryptedFile.addListener(onFileEncrypted);
  }

  onFileEncrypted() async {
    setState(() => uploading = true);
    String fileType =
        lookupMimeType(selectedFile!.path.split('/').last) ?? 'file';
    var res = await fileController.uploadEncryptedFile(
        selectedFile!.path.split('/').last, fileType);
    if (res.isSuccess) {
      showSuccessSnackbar("File uploaded sucessfully!");
      Navigator.pop(ctx);
    } else {
      showCustomErrorSnackbar(res.message);
    }
    setState(() => uploading = false);
  }

  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() => selectedFile = file);
    } else {
      print("no file selected!");
    }
  }

  deleteSelected() => setState(() => selectedFile = null);

  uploadeFile() async {
    setState(() => uploading = true);
    if (fileController.encryptFile) {
      fileController.encryptVaultzFile(selectedFile!);
    } else {
      var res = await fileController.uploadFile(selectedFile!);
      if (res.isSuccess) {
        showSuccessSnackbar("File uploaded sucessfully!");
        Navigator.pop(ctx);
      } else {
        showCustomErrorSnackbar(res.message);
      }
    }
    setState(() => uploading = false);
  }

  String getFileIcon() {
    var ext = selectedFile!.path.split(".").last;
    return "assets/icons/file/ic_${getFileFormat(ext)}.svg";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fileController.encryptedFile.removeListener(onFileEncrypted);
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => setState(() => ctx = context));
    return Scaffold(
      appBar: AppBar(title: Text("Upload File")),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            uploading ? LinearProgressIndicator() : Container(),
            GetBuilder<FileController>(
                builder: (file) => SwitchListTile(
                      value: file.encryptFile,
                      onChanged: (bool) => file.toggleFileEncrypt(),
                      title: Text("Encrypt & Upload"),
                      subtitle: Text("File will be encrypted before uploading"),
                    )),
            Container(
              width: double.maxFinite,
              child: ElevatedButton(
                  onPressed: selectFile, child: Text("Choose File")),
            ),
            selectedFile != null
                ? Column(
                    children: [
                      ListTile(
                          leading: SvgPicture.asset(getFileIcon()),
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute<void>(
                            //     builder: (BuildContext context) => FolderViewPage(
                            //         folderID: folder.id, folderName: folder.name),
                            //   ),
                            // );
                          },
                          title: Text(basename(selectedFile!.path)),
                          subtitle: Text(
                              "Size: ${formatBytes(selectedFile!.lengthSync())}"),
                          trailing: IconButton(
                            padding: EdgeInsets.all(0),
                            alignment: Alignment.centerRight,
                            icon: const Icon(Icons.delete_forever,
                                color: Colors.redAccent),
                            onPressed: deleteSelected,
                          )),
                    ],
                  )
                : Container(),
            uploading
                ? LinearProgressIndicator(color: Colors.redAccent)
                : Container(),
          ],
        ),
      ),
      floatingActionButton: selectedFile != null
          ? FloatingActionButton(
              onPressed: uploading ? null : uploadeFile,
              child: uploading
                  ? CircularProgressIndicator(
                      color: Colors.white60,
                    )
                  : Icon(Icons.check_circle_outline_rounded))
          : Container(),
    );
  }
}
